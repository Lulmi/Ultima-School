import statistics
import numpy as np

acid1 = (5, 8, 9, 4, 2, 12)
acid2 = (21, 4, 12, 5, 13, 6, 8)
acid3 = (14, 3, 12, 4, 5, 1, 21)

media1 = statistics.mean(acid1)
media2 = statistics.mean(acid2)
media3 = statistics.mean(acid3)

print(media1)
print(media2)
print(media3)

print(np.var(acid1))
print(np.var(acid2))
print(np.var(acid3))