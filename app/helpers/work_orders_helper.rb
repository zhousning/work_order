module WorkOrdersHelper
  include StateModule

  def fct_recurrence(factory, result)
    result += factory.name
    if factory.children
      factory.children.each do |fct|
        fct_recurrence(fct, result)
      end
    else
      return result
    end
  end
end
