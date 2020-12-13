const fs = require('fs');

// const csv = fs.readFileSync('./assets/maps/garden.csv');
// const outputPath = './assets/data/garden.txt'

const csv = fs.readFileSync('./assets/maps/simple.csv');
const outputPath = './assets/data/simple.txt'

let tilemap = csv.toString();

const height = (tilemap.match(/\r\n/g) || []).length;
console.log('height', height); 

tilemap = tilemap
  .replace(/\r\n/g, ',')
  .split(',')
  .filter(entry => entry.length)
  .map(item => Number(item));

const width = tilemap.length / height;
console.log('width', width);

const counttable = new Array();

// Walk over each tile and add its neighbors to its entry in the counttable

tilemap.forEach((tile, index) => {
  counttable[tile] = counttable[tile] || { id: tile, f: 0, n: [], s: [], e: [], w: []};
  const neighbors = getNeighbors(index);
  counttable[tile].n.push(...neighbors.n);
  counttable[tile].s.push(...neighbors.s);
  counttable[tile].e.push(...neighbors.e);
  counttable[tile].w.push(...neighbors.w);
  counttable[tile].f += 1;
});

fs.writeFileSync(
  outputPath,
  counttable.filter(used => used !== null)
  .map(count => getTileAsLine(count))
  .join('\n')
);

function getNeighbors(i) {
  // don't care about diagonals

  const neighbors = { n: [], s: [], e: [], w: [] };
  const x = i % width;
  const y = Math.floor(i / width);

  let nnIndex = i - width;
  if (y === 0) {
    nnIndex += tilemap.length;
  }
  const nNeighbor = tilemap[nnIndex];
  neighbors.n.push(nNeighbor);

  let neIndex = i + 1;
  if (x == width - 1) {
    neIndex -= width;
  }
  const eNeighbor = tilemap[neIndex];
  neighbors.e.push(eNeighbor);

  let nsIndex = i + width;
  if (y == height - 1) {
    nsIndex -= tilemap.length;
  }
  const sNeighbor = tilemap[nsIndex];
  neighbors.s.push(sNeighbor);

  let nwIndex = i - 1;
  if (x == 0) {
    nwIndex += width;
  }
  const wNeighbor = tilemap[nwIndex];
  neighbors.w.push(wNeighbor);

  // console.log(x,y, JSON.stringify(neighbors));
  return neighbors;
}

function sortValue(a, b) {
  if (a == b) return 0;
  return Math.abs(a - b) / (a - b);
}

function unique(notuniq) {
  return [...new Set(notuniq)];
}

function neighborString(neighborcount) {
  return unique(neighborcount).sort(sortValue).join(',')
}

function getTileAsLine(tilecount) {
  return `i${tilecount.id},f${tilecount.f},n${neighborString(tilecount.n)},s${neighborString(tilecount.s)},e${neighborString(tilecount.e)},w${neighborString(tilecount.w)}`;
}
