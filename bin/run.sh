#!/usr/bin/env bash

# Synopsis:
# Run the representer on a solution.

# Arguments:
# $1: exercise slug
# $2: absolute path to solution folder
# $3: absolute path to output directory

# Output:
# Writes the test mapping to a mapping.json file in the passed-in output directory.
# The test mapping are formatted according to the specifications at https://github.com/exercism/docs/blob/main/building/tooling/representers/interface.md

# Example:
# ./bin/run.sh two-fer /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./bin/run.sh exercise-slug /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/"
    exit 1
fi

slug="$1"
input_dir="${2%/}"
output_dir="${3%/}"
meta_config_json_file="${input_dir}/.meta/config.json"
representation_file="${output_dir}/representation.txt"
mapping_file="${output_dir}/mapping.json"

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

echo "${slug}: creating representation..."

# TODO: build a representer to generate the representation and mapping files

# As we don't yet analyze the solution files, we'll just concatenate them with
# leading and trailing empty lines removed

# Start with an empty representation file
echo -n '' > "${representation_file}" 

solution_files=$(jq -r '.files.solution[]' "${meta_config_json_file}")
i=0

while read -r relative_solution_file; do
    solution_file="${input_dir}/${relative_solution_file}"

    ## Error when the solution file doesn't exist
    if [[ ! -f "${solution_file}" ]]; then
        >&2 echo "Could not find solution file '${relative_solution_file}'"
        exit 1
    fi

    # Add an empty line to separate multiple files
    if [[ $i > 0 ]]; then
        echo '' >> "${representation_file}"
    fi

    # Append the contents of the solution file to the representation file
    # with any blank lines removed
    sed -E -e 's/\s*$//' -e '/^$/d' "${solution_file}" >> "${representation_file}"

    i=$((i+1))
done <<< "${solution_files}"

# Exit if there an error occured while processing the solution files
if [ $? -ne 0 ]; then
    exit $?
fi

# As we don't yet map any identifiers, we'll just output an empty JSON array
echo '{}' > ${mapping_file}

echo "${slug}: done"
