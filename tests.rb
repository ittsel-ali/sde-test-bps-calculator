# Please follow class names and function names to understand what the unit test case
# about

require_relative 'BPSCalculator'
require "test/unit"
 
class TestBpsCalculator < Test::Unit::TestCase
  
  def test_bps_calculator_should_have_correct_pruned_input_data
    @bsp = BPSCalculator.new("sample_input.json", "sample_output.json")
    
    expected = 
    [
      {"amount_outstanding"=>1200000,
      "id"=>"c1",
      "tenor"=>"10.3 years",
      "type"=>"corporate",
      "yield"=>"5.30%"},
     {"amount_outstanding"=>2500000,
      "id"=>"g1",
      "tenor"=>"9.4 years",
      "type"=>"government",
      "yield"=>"3.70%"},
     {"amount_outstanding"=>1750000,
      "id"=>"g2",
      "tenor"=>"12.0 years",
      "type"=>"government",
      "yield"=>"4.80%"}
    ]

    assert_equal(@bsp.input_data, expected)
  end


  def test_bps_calculator_should_have_correct_corporate_bonds_input
    @bsp = BPSCalculator.new("sample_input.json", "sample_output.json")
    
    expected = 
    [
      {"amount_outstanding"=>1200000,
      "id"=>"c1",
      "tenor"=>"10.3 years",
      "type"=>"corporate",
      "yield"=>"5.30%"}
    ]

    assert_equal(@bsp.corporate_bonds, expected)
  end

  def test_bps_calculator_should_have_correct_government_bonds_input
    @bsp = BPSCalculator.new("sample_input.json", "sample_output.json")
    
    expected = 
    [
      {"amount_outstanding"=>2500000,
      "id"=>"g1",
      "tenor"=>"9.4 years",
      "type"=>"government",
      "yield"=>"3.70%"},
     {"amount_outstanding"=>1750000,
      "id"=>"g2",
      "tenor"=>"12.0 years",
      "type"=>"government",
      "yield"=>"4.80%"}
    ]

    assert_equal(@bsp.government_bonds, expected)
  end

  def test_bps_calculator_should_calculate_correct_bps_output_json
    @bsp = BPSCalculator.new("sample_input.json", "sample_output.json")
    
    expected = 
    { 
      :data=>
        [{
          :corporate_bond_id=>"c1",
          :government_bond_id=>"g1",
          :spread_to_benchmark=>"1.6 bps"
        }]
    }

    assert_equal(@bsp.calculate_bps, expected)
  end
end
