import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import matplotlib.colors as colors

directions = ((-1,0),(0,1),(1,0),(0,-1))
N = 100
grid = np.ones((N,N))
position= [int(N/2),int(N/2)]
direction = 0

def update(data):
    global direction
    x,y = position
    state = grid[x][y]
    if state == 1:
        direction = (direction + 1) % 4
        grid[x][y] = 0
    else:
        direction = (direction - 1) % 4
        grid[x][y] = 1

    position [0] = (position [0] + directions[direction][0]) % N
    position [1] = (position [1] + directions[direction][1]) % N
    mat.set_data(grid)
    #mat.autoscale()
    return mat


fig, ax = plt.subplots()
norm = colors.Normalize(vmin=0, vmax=1)
mat = ax.matshow(grid,norm = norm, cmap=plt.get_cmap('gray'))
ax.axis('off')
ani = animation.FuncAnimation(fig, update, frames = 19,interval=1)
plt.show()
