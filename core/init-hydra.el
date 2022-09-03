;;; core/init-hydra.el -*- lexical-binding: t; -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general
(after! general
  :defer-incrementally t
  :config
  (general-evil-setup)
  (general-imap ";"
    (general-key-dispatch 'self-insert-command
      :timeout 0.5
      ";" 'freedom-english-translate
      "," 'toggle-input-method))
  )
(provide 'init-hydra)
