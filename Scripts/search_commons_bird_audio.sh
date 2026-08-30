#!/bin/zsh

set -euo pipefail

source_file="${1:-ことりサウンド/ViewModels/CrossingViewModel.swift}"
start_index="${2:-0}"
max_species="${3:-999}"
query_mode="${4:-scientific}"

accepted_ids='^(crow|rock_dove|barn_swallow|carrion_crow|common_cuckoo|black_kite|eurasian_wren|indian_peafowl|budgerigar)$'
current_index=0
processed=0

perl -ne '
    if (/\.init\(id: "([^"]+)", title: "([^"]+)", scientificName: "([^"]+)"/) {
        print "$1\t$2\t$3\n";
    }
' "$source_file" |
while IFS=$'\t' read -r bird_id bird_title scientific_name; do
    if [[ "$bird_id" =~ "$accepted_ids" ]]; then
        continue
    fi
    if (( current_index < start_index )); then
        (( current_index += 1 ))
        continue
    fi
    if (( processed >= max_species )); then
        break
    fi

    common_name="${bird_id//_/ }"
    if [[ "$query_mode" == "common" ]]; then
        query_term="$common_name"
    else
        query_term="$scientific_name"
    fi

    response="$(
        curl -L -sS -G 'https://commons.wikimedia.org/w/api.php' \
            -H 'User-Agent: KotoriSoundAudioResearch/1.0 (Wikimedia Commons candidate review)' \
            --data-urlencode 'action=query' \
            --data-urlencode 'format=json' \
            --data-urlencode 'generator=search' \
            --data-urlencode "gsrsearch=\"${query_term}\" filetype:audio" \
            --data-urlencode 'gsrnamespace=6' \
            --data-urlencode 'gsrlimit=5' \
            --data-urlencode 'prop=imageinfo' \
            --data-urlencode 'iiprop=url|extmetadata|mime|size|mediatype'
    )"

    if ! jq -e . >/dev/null 2>&1 <<< "$response"; then
        sleep 1
        (( current_index += 1 ))
        (( processed += 1 ))
        continue
    fi

    matches="$(
        jq -r \
            --arg bird_id "$bird_id" \
            --arg bird_title "$bird_title" \
            --arg scientific_name "$scientific_name" \
            --arg common_name "$common_name" '
                (.query.pages // {})
                | to_entries[]
                | .value as $page
                | $page.imageinfo[0] as $info
                | ($info.extmetadata.LicenseShortName.value // "") as $license
                | ($info.extmetadata.ImageDescription.value // "") as $description
                | ($info.extmetadata.Categories.value // "") as $categories
                | (($page.title + " " + $description + " " + $categories) | ascii_downcase) as $searchable
                | select(
                    $info.mediatype == "AUDIO"
                    and ($license | test("^(CC0|CC BY|CC BY-SA|Public domain|Creative Commons Zero)"; "i"))
                    and (
                        ($searchable | contains($scientific_name | ascii_downcase))
                        or ($searchable | contains($common_name | ascii_downcase))
                    )
                    and (($description | test("pronunciation|prononciation|prononciâtion"; "i")) | not)
                )
                | [
                    $bird_id,
                    $bird_title,
                    $scientific_name,
                    $page.title,
                    $license,
                    ($info.size | tostring),
                    $info.descriptionurl,
                    $info.url,
                    (($info.extmetadata.Artist.value // "") | gsub("<[^>]+>"; "")),
                    (($info.extmetadata.ImageDescription.value // "") | gsub("<[^>]+>"; "") | gsub("[\\n\\r\\t]+"; " "))
                ]
                | @tsv
            ' <<< "$response"
    )"

    if [[ -n "$matches" ]]; then
        print -r -- "$matches"
    fi

    (( current_index += 1 ))
    (( processed += 1 ))
done
