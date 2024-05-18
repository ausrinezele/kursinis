#!/usr/bin/python3
import matplotlib.pyplot as plt
import sys

# Check for command-line arguments
if len(sys.argv) != 3:
    print("Usage: {} <input_kmer_histogram.txt> <output_image.png>".format(sys.argv[0]))
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]

# Read the histogram data
kmer_counts = {}
with open(input_file, 'r') as file:
    for line in file:
        count, freq = line.strip().split()
        kmer_counts[int(count)] = int(freq)

# Prepare data for plotting
counts = list(kmer_counts.keys())
frequencies = [kmer_counts[k] for k in counts]

# Plot the histogram
plt.figure(figsize=(10, 6))
plt.bar(counts, frequencies, log=True)
plt.title('K-mer Histogram')
plt.xlabel('K-mer count')
plt.ylabel('Frequency (log scale)')

# Save the figure
plt.savefig(output_file, dpi=300) 
