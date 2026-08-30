#!/bin/zsh

set -euo pipefail

source_file="${1:-ことりサウンド/ViewModels/CrossingViewModel.swift}"
start_index="${2:-0}"
max_species="${3:-999}"

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
    query="\"${common_name}\"|\"${scientific_name}\""
    response="$(
        curl -L -sS -G 'https://api.openverse.org/v1/audio/' \
            -H 'User-Agent: KotoriSoundAudioResearch/1.0' \
            --data-urlencode "q=${query}" \
            --data-urlencode 'license=cc0,by,by-sa,pdm' \
            --data-urlencode 'page_size=5'
    )"

    if jq -e . >/dev/null 2>&1 <<< "$response"; then
        jq -r \
            --arg bird_id "$bird_id" \
            --arg bird_title "$bird_title" \
            --arg scientific_name "$scientific_name" \
            --arg common_name "$common_name" '
                .results[]?
                | [
                    $bird_id,
                    $bird_title,
                    $scientific_name,
                    .title,
                    (.creator // ""),
                    .license,
                    (.license_version // ""),
                    .source,
                    (.duration | tostring),
                    (.bit_rate | tostring),
                    (.sample_rate | tostring),
                    .foreign_landing_url,
                    .url,
                    (.description // "")
                ]
                | @tsv
            ' <<< "$response"
    fi

    sleep 0.2
    (( current_index += 1 ))
    (( processed += 1 ))
done
