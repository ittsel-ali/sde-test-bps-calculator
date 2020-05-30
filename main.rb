require_relative 'BPSCalculator'
p ARGV[0].inspect
bps = BPSCalculator.new(ARGV[0], ARGV[1])
bps.calculate_bps_to_output_file