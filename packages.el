;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

(package! org-roam-ui :pin "16a8da9e5107833032893bc4c0680b368ac423ac")
(package! go-translate :pin "8bbcbce42a7139f079df3e9b9bda0def2cbb690f")
(package! posframe :pin "0d23bc5f7cfac00277d83ae7ba52c48685bcbc68")
(package! pyim :pin "6b4cea1b541f5efd18067d4cafa1ca4b059a0c63")
(package! pyim-basedict :pin "4aa30ff9f83cf6435230a987d323e48230f1f40e")
(package! nov :pin "ea0c835c1b5e6e70293f4bd64e9c89bdc42f8596")
(package! telega :pin "42a0dd0e30a82a8e34eaccf6e7a1366f4621d49d");; 1.8.4
;; (package! telega :pin "66e83c8674042d47bf2cada05192f3d0b7e967a1");; 1.8.0
(package! theme-changer :pin "57b8c579f134374a45bec9043feff6b29bb4f108")
(package! calibredb :recipe (:host github :repo "chenyanming/calibredb.el" :files ("*.el")) :pin "2f2cfc38f2d1c705134b692127c3008ac1382482")
(package! rime :recipe (:host github :repo "DogLooksGood/emacs-rime" :files ("*.el" "Makefile" "lib.c")) :pin "3eeef9c445fa056a4b32137f9ef72c27ced2d4ab")
;;(package! doom-modeline :pin "ce9899f00af40edb78f58b9af5c3685d67c8eed2")
(package! projectile-ripgrep)
(package! ripgrep)
(package! meow :pin "4ad1a11d14c8bc0ba4137900c7833fbdacf7bdb3")
