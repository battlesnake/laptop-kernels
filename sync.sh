#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

(
	cd ..

	for dir in */; do
		if ! [ -e "${dir}"/VERSION ]; then
			continue;
		fi
		declare ver="${dir%/}"
		printf -- "\e[35m%s\e[0m\n" "${ver}"
		(
			cd "${ver}"
			make clean
		)
		tar -c "${ver}" | pigz -c9 -p10 | split -b 40MiB - github/"${ver}".tar.gz_
		echo ""
	done

)

git add *.gz

git commit -m "Sync $(date -uIseconds)"

du -cs -BM *

git push -u origin master
