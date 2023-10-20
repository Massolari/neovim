(local {: require-and} (require :functions))

{1 :glacambre/firenvim
 :cond (not (not vim.g.started_by_firenvim))
 :build (fn []
          (require-and :lazy #($.load {:plugins :firenvim :wait true}))
          (vim.fn.firenvim#install 0))
 :init (fn []
         (set vim.g.firenvim_config {:localSettings {:.* {:takeover :never}}}))}
