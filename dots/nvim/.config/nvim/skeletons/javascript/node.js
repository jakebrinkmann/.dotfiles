#!/usr/bin/env node

async function main() {
  // process.argv[2]
  // process.env.USER
}

main().catch(err => {
  console.error(err.stack);
  process.exit(1);
});
