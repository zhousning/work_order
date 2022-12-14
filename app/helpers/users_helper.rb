module UsersHelper

   def options_for_role(*role)
     str = ""
     roles = Role.where(:level => "1")
     roles.each do |item|
       if !role.blank? && item.id == role.first.id    
         str += "<option selected='selected' value='" + item.id.to_s + "'>" + item.name + "</option>"
       else                     
         str += "<option value='" + item.id.to_s + "'>" + item.name + "</option>"
       end
     end
     raw(str)
   end
end
