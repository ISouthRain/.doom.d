;;; core/init-lsp.el -*- lexical-binding: t; -*-

(use-package dumb-jump
  :defer 1
  :config
  (setq dumb-jump-force-searcher 'ag))

(provide 'init-lsp)
