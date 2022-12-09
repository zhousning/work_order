module WorkOrdersHelper

   def order_state(state)
     state_hash = {
       Setting.states.opening    => Setting.state_labels.opening, 
       Setting.states.assign     => Setting.state_labels.assign, 
       Setting.states.processing => Setting.state_labels.processing, 
       Setting.states.transfer   => Setting.state_labels.transfer, 
       Setting.states.awaiting   => Setting.state_labels.awaiting, 
       Setting.states.unsettled  => Setting.state_labels.unsettled, 
       Setting.states.completed  => Setting.state_labels.completed
     }
     state_hash[state]
   end
end
