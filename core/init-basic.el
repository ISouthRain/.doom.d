;;; core/init-basic.el -*- lexical-binding: t; -*-


(defun freedom-hugo-home ()
  (interactive)
  (if freedom/is-windows
      (find-file "F:\\Hugo\\content\\posts\\Home.md"))
  (if freedom/is-termux
      (find-file "~/Ubuntu/ubuntu-fs/root/Hugo/content/posts/Home.md"))
  (if freedom/is-darwin
      (find-file "~/Desktop/Hugo/content/posts/Home.md"))
  (if freedom/is-linux
      (if (not freedom/is-termux)
          (find-file "~/f/Hugo/content/posts/Home.md")))
  )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Automatically replace the topic according to time
(when (not freedom/is-termux)
  (use-package! theme-changer
    ;; :unless IS-MAC
    :init
    (setq calendar-location-name "香洲, GD")
    ;; (setq calendar-latitude 39.9)
    ;; (setq calendar-longitude 116.3)
    (setq calendar-latitude 22.17)
    (setq calendar-longitude 113.34)
    :config
    ;; Automatic replacement icon
    (add-hook! 'doom-load-theme-hook
      (setq fancy-splash-image
            (let ((banners (directory-files (expand-file-name "banner" doom-private-dir)
                                            'full
                                            (rx ".png" eos))))
              (elt banners (random (length banners))))))

    ;; The theme list of automatic replacement
    (defconst +list-light-theme '(doom-one-light
                                  doom-nord-light
                                  doom-opera-light
                                  doom-tomorrow-day))
    (defconst +list-dark-theme  '(doom-one
                                  doom-vibrant
                                  doom-city-lights
                                  doom-challenger-deep
                                  doom-dracula
                                  doom-gruvbox
                                  doom-horizon
                                  doom-Iosvkem
                                  doom-material
                                  doom-molokai
                                  doom-monokai-classic
                                  doom-monokai-pro
                                  doom-moonlight
                                  doom-oceanic-next
                                  doom-palenight
                                  doom-peacock
                                  doom-rouge
                                  doom-snazzy
                                  doom-spacegrey
                                  doom-tomorrow-night))
    (add-hook! after-init
               :append
               (change-theme +list-light-theme
                             +list-dark-theme)))
  )
(provide 'init-basic)
