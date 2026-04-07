function remove
    if test "$argv[1]" = "orphans"
        set orphans (pacman -Qtdq)

        if test (count $orphans) -eq 0
            echo "No orphan packages found!"
            return 0
        end

        sudo pacman -Rns $orphans
    else
        echo "Usage: remove orphans"
    end
end
