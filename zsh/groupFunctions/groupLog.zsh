#!/bin/zsh

groupLog() {
	local podPattern=$1
	local jobOrApi=$2
	local outputDir="$HOME/Desktop/GroupPortalLogs"
	local outputFile="$outputDir/$podPattern.txt"

	mkdir -p "$outputDir"

	if [[ -f "$outputFile" ]]; then
		rm "$outputFile"
	fi

	for matchedPod in $(kubectl get pods -n mci-prod | awk "/$podPattern/ && /$jobOrApi/ {print \$1}"); do
		kubectl logs -n mci-prod "$matchedPod" >>"$outputFile"
	done

	echo "Logs saved to $outputFile"
}

memberLookupLog() {
	local podPattern="memberlookup"
	local outputDir="$HOME/Desktop/MemberLookupLogs"
	local outputFile="$outputDir/$podPattern.txt"

	mkdir -p "$outputDir"

	if [[ -f "$outputFile" ]]; then
		rm "$outputFile"
	fi

	for matchedPod in $(kubectl get pods -n mci-prod | awk "/$podPattern/ {print \$1}"); do
		kubectl logs -n mci-prod "$matchedPod" >>"$outputFile"
	done

	echo "Logs saved to $outputFile"
}
