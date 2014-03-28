class Person < ActiveRecord::Base
  validates :name, :presence => true

  after_save :make_marriage_reciprocal

  def spouse
    if spouse_id.nil?
      nil
    else
      Person.find(spouse_id)
    end
  end

  def parent1
    if parent1_id.nil?
      nil
    else
      Person.find(parent1_id)
    end
  end

  def parent2
    if parent2_id.nil?
      nil
    else
      Person.find(parent2_id)
    end
  end

  def parents
    if parent1_id.nil? || parent2_id.nil?
      nil
    else
      Person.find(parent1_id, parent2_id)
    end
  end

  def grandparents
    if Person.where(:parent1_id => "#{self.id}", :parent2_id => "#{self.id}").count == 0
      return nil
    else
      parent1 = Person.find(parent1_id)
      parent2 = Person.find(parent2_id)
      Person.find(parent1.parent1_id, parent1.parent2_id, parent2.parent1_id, parent2.parent2_id)
    end
  end

  def kids
    if Person.where(:parent1_id => "#{self.id}").count == 0
      return nil
    else
    Person.where(:parent1_id => "#{self.id}")
    end
  end

  def grandkids
    if self.kids == nil
      nil
    else
      grandkids = []
        self.kids.each do |kid|
          unless kid.kids == nil
            kid.kids.each do |grandkid|
            grandkids << grandkid
          end
        end
      end
    end

    if grandkids.count == 0
      nil
    else
      grandkids
    end
  end

private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
