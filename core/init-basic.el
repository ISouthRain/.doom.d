;;; core/init-basic.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; function define
(defun freedom/evil-quit ()
  "Quit current window or buffer."
  (interactive)
  (if (> (seq-length (window-list (selected-frame))) 1)
      (delete-window)
    (previous-buffer)))

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
;; basic configuration
(display-time-mode 1) ;; 常显
(setq display-time-24hr-format t) ;;格式
(setq display-time-day-and-date t) ;;显示时间、星期、日期
;; 显示电池
(if (display-graphic-p)
    (display-battery-mode 1))

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 窗口透明
(defun sanityinc/adjust-opacity (frame incr)
  "Adjust the background opacity of FRAME by increment INCR."
  (unless (display-graphic-p frame)
    (error "Cannot adjust opacity of this frame"))
  (let* ((oldalpha (or (frame-parameter frame 'alpha) 100))
         (oldalpha (if (listp oldalpha) (car oldalpha) oldalpha))
         (newalpha (+ incr oldalpha)))
    (when (and (<= frame-alpha-lower-limit newalpha) (>= 100 newalpha))
      (modify-frame-parameters frame (list (cons 'alpha newalpha))))))
(defhydra hydra-freedom-AdjustOpacity(:color pink
                                     :hint nil
                                     :foreign-keys warn ;; 不要使用hydra以外的键
                                     )
  "
_j_: 增加 _k_: 减少 _g_: 重置
"
  ("j"  (sanityinc/adjust-opacity nil 2) :exit nil)
  ("k"  (sanityinc/adjust-opacity nil -2) :exit nil)
  ("g"  (modify-frame-parameters nil `((alpha . 100))) :exit nil)
  ("q" nil "cancel")
  ("<escape>" nil "cancel")
  )

(provide 'init-basic)
