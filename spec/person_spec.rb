require 'spec_helper'

describe Person do
  it { should validate_presence_of :name }

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

  context '#kids' do
    it "returns one kid if there is only one kid" do
      guy = Person.create(:name => 'Guy')
      jane = Person.create(:name => 'Jane')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id, :parent2_id => jane.id)
      guy.kids.first.should eq tom
    end

    it "returns all of a person's kids" do
      guy = Person.create(:name => 'Guy')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id)
      jimmy = Person.create(:name => 'Jimmy', :parent1_id => guy.id)
      john = Person.create(:name => 'John', :parent1_id => guy.id)
      guy.kids.should eq [tom, jimmy, john]
    end
  end

  context '#siblings' do
    it "returns all of a person's siblings" do
      guy = Person.create(:name => 'Guy')
      jane = Person.create(:name => 'Jane')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id, :parent2_id => jane.id)
      lenny = Person.create(:name => 'Lenny', :parent1_id => guy.id, :parent2_id => jane.id)
      tom.siblings.should eq [lenny]
      lenny.siblings.should eq [tom]
    end

    it "returns nil for a person with no siblings" do
      guy = Person.create(:name => 'Guy')
      jane = Person.create(:name => 'Jane')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id, :parent2_id => jane.id)
      guy.siblings.should eq nil
    end
  end

  context '#nieces_and_nephews' do
    it "returns all of a person's nieces and nephews" do
      guy = Person.create(:name => 'Guy')
      jane = Person.create(:name => 'Jane')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id, :parent2_id => jane.id)
      lenny = Person.create(:name => 'Lenny', :parent1_id => guy.id, :parent2_id => jane.id)
      karen = Person.create(:name => 'Karen')
      leslie = Person.create(:name => 'Leslie', :parent1_id => lenny.id, :parent2_id => karen.id)
      tom.nieces_and_nephews.should eq [leslie]
    end

    it "returns nil for a person with no nieces or nephews" do
      guy = Person.create(:name => 'Guy')
      jane = Person.create(:name => 'Jane')
      tom = Person.create(:name => 'Tom', :parent1_id => guy.id, :parent2_id => jane.id)
      lenny = Person.create(:name => 'Lenny', :parent1_id => guy.id, :parent2_id => jane.id)
      karen = Person.create(:name => 'Karen')
      tom.nieces_and_nephews.should eq nil
    end
  end

  context '#reload' do
    it "updates the spouse's id when it's spouse_id is changed" do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      earl.reload
      earl.spouse_id.should eq steve.id
    end
  end
end
