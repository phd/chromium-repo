#!/bin/bash -e

cd $(dirname "$0")
DIR=$(pwd)

. config

COUNTER_EXTENSION='.DOWNLOADS'

LF=$'\n'

function print_array {
    local -n array="$1"
    printf '%s\n' "${array[@]}"
}

function epoch {
    echo "$(date --utc -d "${1}" '+%s')"
}

function trim {
    sed -E -e '1h;2,$H;$!d;g' -e 's/^[[:space:]]*//;s/[[:space:]]*$//' <<< "${!1}"
}

readarray -t dirs < <(
    for RELEASE in $RELEASES; do
        UBUNTU=${RELEASE%%/*}
        MINT=${RELEASE#*/}
        find "${UBUNTU}/pool" -type d -name 'chromium_*'
    done | sort -t/ -k 3,3V -k 1,1
)

readarray -t versions < <(
    print_array dirs | sed -E 's,^([^/]+)/pool/chromium_([^~]+).*$,\2 \1,'
)
VERSIONS_COUNT="${#versions[@]}"

colors=()
for version in "${versions[@]}"; do
    color="$(md5sum <<< "${version}" | cut -c2-7 | tr '012def' '333ccc')"
    colors+=("${color}")
done

TODAY="$(date --utc '+%Y-%m-%d')"

downloads=()
totals=()
DATE_MIN="${TODAY}"
DATE_MAX="${TODAY}"
for dir in "${dirs[@]}"; do
    counter="$(echo $dir/chromium_*.deb${COUNTER_EXTENSION})"
    counts=''
    if [ -f "${counter}" ]; then
        counts="$(< ${counter})"
    fi
    downloads+=("${counts}")
    total=0
    while read date count; do
        [ -z "$date" ] && continue
        ((total+=count)) || true
        if [ "$(epoch ${date})" -lt "$(epoch ${DATE_MIN})" ]; then
            DATE_MIN="${date}"
        fi
        if [ "$(epoch ${date})" -gt "$(epoch ${DATE_MAX})" ]; then
            DATE_MAX="${date}"
        fi
    done <<< "${counts}"
    totals+=("${total}")
done
epoch_min="$(epoch $DATE_MIN)"
epoch_max="$(epoch $DATE_MAX)"
DAYS_COUNT="$(( (${epoch_max} - ${epoch_min}) / (24*60*60) + 1 ))"

indent='                  '
VERSIONS_DATASET=''
VERSIONS_DATASET+="${indent}data: [${LF}"
for i in "${!versions[@]}"; do
    VERSIONS_DATASET+="${indent}  { x: '${versions[$i]}', y: ${totals[$i]} },${LF}"
done
VERSIONS_DATASET+="${indent}],${LF}"
VERSIONS_DATASET+="${indent}backgroundColor: [${LF}"
for color in "${colors[@]}"; do
    VERSIONS_DATASET+="${indent}  '#${color}66',${LF}"
done
VERSIONS_DATASET+="${indent}],${LF}"
VERSIONS_DATASET+="${indent}borderColor: [${LF}"
for color in "${colors[@]}"; do
    VERSIONS_DATASET+="${indent}  '#${color}ff',${LF}"
done
VERSIONS_DATASET+="${indent}],${LF}"
VERSIONS_DATASET="$(trim VERSIONS_DATASET)"

indent='                '
DAILY_DATASETS=''
order=0
for i in "${!versions[@]}"; do
    ((order--)) || true
    DAILY_DATASETS+="${indent}{${LF}"
    DAILY_DATASETS+="${indent}  order:           ${order},${LF}"
    DAILY_DATASETS+="${indent}  label:           '${versions[$i]}',${LF}"
    DAILY_DATASETS+="${indent}  backgroundColor: ['#${colors[$i]}ff'],${LF}"
    DAILY_DATASETS+="${indent}  borderColor:     ['#${colors[$i]}66'],${LF}"
    DAILY_DATASETS+="${indent}  spanGaps:        1*24*60*60*1000,${LF}"
    DAILY_DATASETS+="${indent}  data: [${LF}"
    while read date count; do
        [ -z "$date" ] && continue
        DAILY_DATASETS+="${indent}    { x: '${date}', y: ${count} },${LF}"
    done <<< "${downloads[$i]}"
    DAILY_DATASETS+="${indent}  ]${LF}"
    DAILY_DATASETS+="${indent}},${LF}"
done
DAILY_DATASETS="$(trim DAILY_DATASETS)"

output="$(< stats.html.skel)"
output=${output/"%(TODAY)"/"${TODAY}"}
output=${output/"%(DATE_MIN)"/"${DATE_MIN}"}
output=${output/"%(DATE_MAX)"/"${DATE_MAX}"}
output=${output/"%(DAYS_COUNT)"/"${DAYS_COUNT}"}
output=${output/"%(DAILY_DATASETS)"/"${DAILY_DATASETS}"}
output=${output/"%(VERSIONS_COUNT)"/"${VERSIONS_COUNT}"}
output=${output/"%(VERSIONS_DATASET)"/"${VERSIONS_DATASET}"}
echo "${output}" > stats.html

exit 0
