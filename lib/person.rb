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

  def kids
    if Person.where("parent1_id = ? or parent2_id = ?", self.id, self.id).count == 0
      nil
    else
      Person.where("parent1_id = ? or parent2_id = ?", self.id, self.id)
    end
  end

  def siblings
    if parent1_id.nil? || parent2_id.nil?
      nil
    elsif Person.where.not("id = ?", self.id).where("parent1_id = ? and parent2_id = ?", self.parent1.id, self.parent2.id).count == 0
      nil
    else
      Person.where.not("id = ?", self.id).where("parent1_id = ? or parent2_id = ?", self.parent1.id, self.parent2.id)
    end
  end

  def nieces_and_nephews
    n_array = []
    if self.siblings == nil
      nil
    else
      self.siblings.each do |sibling|
        unless sibling.kids == nil
          sibling.kids.each do |n|
              n_array << n
          end
        end
      end
    end

    if n_array.count == 0
      nil
    else
      n_array
    end
  end

  def cousins
    c_array = []
    if self.parents == nil
      nil
    else
      self.parents.each do |parent|
        unless parent.nieces_and_nephews == nil
          parent.nieces_and_nephews.each { |c| c_array << c }
        end
      end
      c_array
    end
  end


private

  def make_marriage_reciprocal
    if spouse_id_changed?
      spouse.update(:spouse_id => id)
    end
  end
end
