#!/bin/bash
# this file is only meant for making these dotfiles usable on gitpod.io

current_dir="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
echo "I am running from: $current_dir"

dotfiles_source="${current_dir}/home_files"

while read -r file; do

    relative_file_path="${file#"${dotfiles_source}"/}"
    target_file="${HOME}/${relative_file_path}"
    target_dir="${target_file%/*}"

    if test ! -d "${target_dir}"; then
      echo "mkdir ${target_dir} "
      mkdir -p "${target_dir}"
    fi

    printf 'Installing dotfiles symlink %s\n' "${file}  ${target_file}"
    ln -sf "${file}" "${target_file}"

#done <   <(echo .bashrc .profile)
done < <(find "${dotfiles_source}" -type f)
