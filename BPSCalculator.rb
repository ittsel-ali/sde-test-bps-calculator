class BPSCalculator
  require "json"

  attr_reader   :output_file_path
  attr_accessor :input_data, :output_data
  
  def initialize(input_file_path, output_file_path)
    @output_file_path = output_file_path
    
    input_file        = File.open(input_file_path)
    load_pruned_data(input_file)
    
    input_file.close
  end

  def output_data(spread="", corporate_id="", government_id="")
    @output_data = 
    {
      data: [
        {
          corporate_bond_id:    corporate_id,
          government_bond_id:   government_id,
          spread_to_benchmark:  "#{spread} bps"
        }
      ]
    }
  end

  def corporate_bonds
    input_data.reject{|k| k["type"] == "government"}
  end

  def government_bonds
    input_data.reject{|k| k["type"] == "corporate"}
  end

  def calculate_bps
    result = output_data("","","")
  
    min_spread = 1000.0
  
    corporate_bonds.each do |c_bond|
      spread, g_bond =  get_spread_for_corporate_bond(c_bond, government_bonds)
      
      if spread < min_spread
        min_spread = spread
        result = output_data( spread, c_bond["id"], g_bond["id"])
      end 
    end 
    
    result
  end

  def calculate_bps_to_output_file
    file = File.open( output_file_path, "w" )
    file.write( calculate_bps )
    file.close
  end
  
  private

  def load_pruned_data(input_file)
    file_data   = JSON.load(input_file)["data"] rescue []
    
    @input_data = file_data.reject{|k| 
      k["tenor"].nil? || k["type"].nil? || k["yield"].nil? || k["id"].nil? || k["amount_outstanding"].nil?
    }
  end

  def get_spread_for_corporate_bond(c_bond, g_bonds)
    closest_tenor_diff = (g_bonds[0]['tenor'].to_f - c_bond['tenor'].to_f).abs
    g_bond = g_bonds[0]
    spread = c_bond['yield'].to_f - g_bonds[0]['yield'].to_f

    g_bonds.each do |bond|
      diff = (bond['tenor'].to_f - c_bond['tenor'].to_f).abs
      
      if diff < closest_tenor_diff
        closest_tenor_diff = diff
        spread = c_bond['yield'].to_f - bond['yield'].to_f
        g_bond = bond
      end
    end

    [spread.to_f.round(2).abs, g_bond]
  end
  
end
