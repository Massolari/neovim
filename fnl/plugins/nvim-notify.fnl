(local stages-util (require :notify.stages.util))

(fn slide-from [direction]
  [(fn [state]
     (let [next-height (+ 3 state.message.height)
           next-row (stages-util.available_slot state.open_windows next-height
                                                direction)]
       (when next-row
         {:relative :editor
          :anchor :NE
          :width 1
          :height state.message.height
          :col (vim.opt.columns:get)
          :row next-row
          :border :rounded
          :style :minimal})))
   (fn [state]
     {:width {1 state.message.width :frequency 2} :col [(vim.opt.columns:get)]})
   (fn []
     {:col [(vim.opt.columns:get)] :time true})
   (fn []
     {:width {1 1 :frequency 2.5 :damping 0.9 :complete #(< $1 2)}
      :col [(vim.opt.columns:get)]})])

(local notify (require :notify))

(notify.setup {:stages (slide-from stages-util.DIRECTION.BOTTOM_UP)})

(set vim.notify notify)
