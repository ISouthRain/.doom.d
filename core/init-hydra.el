;;; core/init-hydra.el -*- lexical-binding: t; -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general
(use-package! general
  :defer-incrementally t
  :config
  (general-evil-setup)
  (general-imap ";"
                (general-key-dispatch 'self-insert-command
                  :timeout 0.5
                  ";" 'toggle-input-method))
  )
(provide 'init-hydra)
