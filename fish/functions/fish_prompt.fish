function fish_prompt
    set -l last_status $status

    if test $last_status -ne 0
        set_color ff7b72
        printf '! '
        set_color normal
    end

    set_color 42be65
    printf '› '
    set_color normal
end
