require File.dirname(__FILE__) + '/spec_helper'

describe GeographyDivisionSelect::FormHelpers do
  it "should include geography_division_select method" do
    ActionView::Helpers::FormBuilder.instance_methods.should include('geography_division_select')
  end
end 


describe  GeographyDivisionSelect::FormHelpers do
  include GeographyDivisionSelect::FormHelpers
 
  before do
    self.stub!(:params).and_return({})
  end
 
  describe "using geography_division_select as a plain tag" do
    before do
      @user = mock('User', :place => nil)
    end
    
    it "should output all regions" do
      output = geography_division_select("geography", "geography")
      output.should have_tag('select') do
       with_tag('option', 7)
      end
      output.should have_tag('option[value=?]',"Antartica")
    end

    it "should output all regions for drilldown type region" do
      output = geography_division_select("geography", "geography",:drilldown=>"region")
      output.should have_tag('select') do
       with_tag('option',7)
      end
      output.should have_tag('option[value=?]',"Antartica")
    end

    it "should output all regions for drilldown type region with only condition" do
      output = geography_division_select("geography","geography",:drilldown=>"region",:only=>{:region=>"Europe,North America,South America"}) 
      output.should have_tag('select') do
       with_tag('option',3)
      end
      output.should_not have_tag('option[value=?]',"Asia")
      output.should have_tag('option[value=?]',"North America")
    end

    it "should output all regions for drilldown type region with exclude condition (Asia & Europe)" do
      output = geography_division_select("geography","geography",:drilldown=>"region",:exclude=>{:region=>"Asia,Europe"}) 
      output.should have_tag('select') do
       with_tag('option',5)
      end
      output.should_not have_tag('option[value=?]',"Asia")
      output.should_not have_tag('option[value=?]',"Europe")
      output.should have_tag('option[value=?]',"North America")
    end

    it "should output only regions for Asia & Europe with only countries India, UnitedKingdom, France and Indonesia" do
      output = geography_division_select("geography","geography",:drilldown=>"country",:only=>{:region=>"Asia,Europe",:country=>"India,UnitedKingdom,France,Indonesia"}) 
      output.should have_tag('select') do
       with_tag('option',4)
      end
      output.should_not have_tag('option[value=?]',"China")
      output.should_not have_tag('option[value=?]',"Germany")
      output.should have_tag('option[value=?]',"India")
      output.should have_tag('option[value=?]',"France")
    end


       it "should output only regions for Asia & Europe with excluding countries India, UnitedKingdom, France and Indonesia" do
      output = geography_division_select("geography","geography",:drilldown=>"country",:only=>{:region=>"Asia,Europe"},:exclude=>{:country=>"India,UnitedKingdom,France,Indonesia"}) 
      output.should have_tag('select') do
      with_tag('option')
      end
      output.should_not have_tag('option[value=?]',"India")
      output.should_not have_tag('option[value=?]',"France")
      output.should have_tag('option[value=?]',"China")
      output.should have_tag('option[value=?]',"Germany")
    end


       it "should output only countries India, Japan and South Africa" do
      output = geography_division_select("geography","geography",:drilldown=>"country",:exclude=>{:region=>"Asia,South America"},:only=>{:country=>"India,Japan,South Africa", :region=>"Europe"}) 
      output.should have_tag('select') do
      with_tag('option', 3)
      end
      output.should have_tag('option[value=?]',"India")
      output.should_not have_tag('option[value=?]',"Nepal")
      output.should_not have_tag('option[value=?]',"Brazil")
      output.should have_tag('option[value=?]',"Japan")
      output.should_not have_tag('option[value=?]',"Europe")
    end

       it "should output all countries which are not part of Asia and South America regions and the countries listed in the country exclude section" do
      output = geography_division_select("geography","geography",:drilldown=>"country",:exclude=>{:region=>"Asia,South America",:country=>"France,United States of America,United Kingdom"}) 
      output.should have_tag('select') do
      with_tag('option')
      end
      output.should_not have_tag('option[value=?]',"India")
      output.should_not have_tag('option[value=?]',"France")
      output.should have_tag('option[value=?]',"Germany")
    end


  end 
  
  
  # using geography_division_select as a selected options
    describe "using geography_division_select as selected options" do
    before do
      @user = mock('User', :place => nil)
    end
    
       it "should output all regions of the world with Asia Selected" do
      output = geography_division_select("geography","geography",:drilldown=>"region",:selected=>"Asia")
      output.should have_tag('select') do
      with_tag('option',7)
      end
       output.should have_tag("option[value=?]","Asia")do
         with_tag('option[selected]')
       end
    end


      it "should output all the states of india" do
        output = geography_division_select("geography","geography",:drilldown=>"state",:only=>{:country=>"India"}, :selected=>"Karnataka")
        output.should have_tag('select') do
        with_tag('option',35)
      end
        output.should have_tag("option[value=?]","Karnataka") do
          with_tag('option[selected]')
        end
        output.should_not have_tag("option[value=?]","New Jersey") 
    end
    
  end
  
  
  
  # using geography_division_select as a priority options
  describe "using geography_division_select as priority options" do
    before do
      @user = mock('User', :place => nil)
    end
    
       it "should output all 7 + 3 + 1 regions of the world with Asia, North America and Europe in the priority segment" do
      output = geography_division_select("geography","geography",:drilldown=>"region",:priority=>"Asia,North America,Europe")
      output.should have_tag('select') do
      with_tag('option',11)
      end
    end

       it "should output all 239 + 3 + 1 countries of the world with USA, UK and India being in the priority list" do
      output = geography_division_select("geography","geography",:drilldown=>"country",:priority=>"United States Of America,United Kingdom,India")
      output.should have_tag('select') do
      with_tag('option', 243)
      end
    end
  end
  
 end
