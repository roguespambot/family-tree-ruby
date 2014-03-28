require 'spec_helper'

describe Person do
  it { should validate_presence_of :name }
  # it { should validate_presence_of :parent1_id }
  # it { should validate_presence_of :parent2_id }

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end
  end

  context '#parent1' do
    it 'returns the person with one of their parent_ids' do
      tom = Person.create(:name => 'Tom')
      jane = Person.create(:name => 'Jane')
      frank = Person.create(:name => 'Frank', :parent1_id => tom.id)
      frank.parent1.should eq tom
    end
  end

  context '#parent2' do
    it 'returns the person with the other of their parent_ids' do
      tom = Person.create(:name => 'Tom')
      jane = Person.create(:name => 'Jane')
      frank = Person.create(:name => 'Frank', :parent2_id => jane.id)
      frank.parent2.should eq jane
    end
  end

  context '#parents' do
    it 'returns the person with both of their parent_ids' do
      tom = Person.create(:name => 'Tom')
      jane = Person.create(:name => 'Jane')
      frank = Person.create(:name => 'Frank', :parent1_id => tom.id, :parent2_id => jane.id)
      frank.parents.should eq [tom, jane]
    end
  end

  context '#grandparents' do
    it "returns all four of a person's grandparents" do
      guy = Person.create(:name => 'Guy')
      lenna = Person.create(:name => 'Lenna')
      evelyn = Person.create(:name => 'Evelyn')
      joseph = Person.create(:name => 'Joseph')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id, :parent2_id => lenna.id)
      jane = Person.create(:name => 'Jane', :parent1_id => evelyn.id, :parent2_id => joseph.id)
      frank = Person.create(:name => 'Frank', :parent1_id => tom.id, :parent2_id => jane.id)
      frank.grandparents.should eq [guy, lenna, evelyn, joseph]
    end
  end

  context '#children' do
    it "returns one child if there is only one child" do
      guy = Person.create(:name => 'Guy')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id)
      guy.children.first.should eq tom
    end

    it "returns all of a person's children" do
      guy = Person.create(:name => 'Guy')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id)
      jimmy = Person.create(:name => 'Jimmy', :parent1_id => guy.id)
      john = Person.create(:name => 'John', :parent1_id => guy.id)
      guy.children.should eq [tom, jimmy, john]
    end
  end

  context '#grandchildren' do
    it "returns one grandchild if there is only one grandchild" do
      guy = Person.create(:name => 'Guy')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id)
      frank = Person.create(:name => 'Frank', :parent1_id => tom.id)
      guy.grandchildren.should eq [frank]
    end

    it "returns multiple grandchildren if there are multiple grandchildren" do
      guy = Person.create(:name => 'Guy')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id)
      frank = Person.create(:name => 'Frank', :parent1_id => tom.id)
      dave = Person.create(:name => 'Dave', :parent1_id => guy.id)
      rachel = Person.create(:name => 'Rachel', :parent1_id => dave.id)
      guy.grandchildren.should eq [frank, rachel]
    end

    it "returns nil if there are no grandchildren" do
    guy = Person.create(:name => 'Guy')
    guy.grandchildren.should eq nil
    end

    it "works if some children have grandchildren while others do not" do
      guy = Person.create(:name => 'Guy')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id)
      frank = Person.create(:name => 'Frank', :parent1_id => tom.id)
      dave = Person.create(:name => 'Dave', :parent1_id => guy.id)
      guy.grandchildren.should eq [frank]
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end
end
