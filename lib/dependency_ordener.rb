class DependencyOrdener
  
  # Given a collection of ActiveRecord models, returns an
  # array of the same models in the order where no model 
  # has a foreign key to a following model. If this order is 
  # nonexistent, an error is raised
  def order models
    @belongings = {}

    build_belongings models
    
    result = []
    until @belongings.empty?
      next_on_list = pick_next
      remove_belonger next_on_list
      remove_belongee next_on_list
      result << next_on_list
    end
    result
  end

  private

    def build_belongings models
      models.each do |m|
        @belongings[m] = m.reflections
          .select{|name, reflection| reflection.macro == :belongs_to}
          .values.map do |reflection|
            if reflection.options[:polymorphic]
              find_polymorphic_types models, reflection.foreign_type
            else
              reflection.foreign_type[0..-6].camelize.constantize
            end
          end
          .flatten
      end
    end

    def find_polymorphic_types models, type
      models.map(&:reflections)
        .map(&:values)
        .flatten
        .select{|r| r.type == type}
        .map(&:active_record)
    end

    def pick_next 
      belongings_item = @belongings.find{|belonger, belongees| belongees.empty?}
      if belongings_item
        belongings_item.first
      else
        raise "Circular belongs_to dependencies: Can not deduce order!"
      end
    end

    def remove_belongee belongee
      @belongings.each do |belonger, belongees|
        belongees.delete(belongee)
      end
    end

    def remove_belonger belonger
      @belongings.delete belonger
    end

end