# Solidity Cheatsheet (1/5) 

[![Solidity 0.8.20](https://img.shields.io/badge/Solidity-0.8.20-363636?logo=solidity)](https://soliditylang.org)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)
![GitHub Repo stars](https://img.shields.io/github/stars/AtharvSan/solidity_cheatsheet)


solidity short notes and examples that compile. You can now keep all your nuanced learnings stacked up in one place.

![contract interface example](./types.png)
![call example](./call.png)


## Features

- **Beginner Friendly** - well structured notes explained in plain english
- **Clean Structure** - better organization, no confusion
- **Nuanced Notes** - edges around using certain solidity featurs are well addressed


## Highlights

| Section               | Highlights                          | Pro Tip Included? |
|-----------------------|-------------------------------------|-------------------|
| **OOP**               | C3 Linearization, `super` vs `override` | ✅            |
| **Low-Level Calls**   | When to use `delegatecall`          | ✅                |
| **Bitmasking**        | Pack 2x uint128 into 1 uint256      | ✅ (Packing demo) |
| **ABI Encoding**      | hash collisions encode vs encodePacked | ✅           |
| **type conversions**  | datatype nuances                    | ✅ (implicit explicit)|
| **error handling**    | throwing vs bubbling                | ✅ (try-catch)    |


## Getting Started
### foundry
```bash
  git clone https://github.com/AtharvSan/solidity_cheatsheet.git
  cd solidity_cheatsheet
  forge install
  forge compile
```
### remix 
just copy the code from src/solidity_cheatsheet.sol into remixIDE and you can start playing around.

## Roadmap
Part 1 of a 5 part series on essentials for solidity devs
- solidity_cheatsheet.sol
- cryptography_cheatsheet.sol
- assembly_cheatsheet.sol
- designPatterns_cheatsheet.sol
- security_cheatsheet.sol 

## ❓ FAQ

**Q: How is this different from Solidity docs?**  
A: you get to try all the features at once place, more experimentation means more learning.

**Q: Why Foundry?**  
A: Industry-standard testing framework - but Remix works too!

**Q: Can I contribute?**  
A: Yes! contributors are welcome.

## 📜 License
This project is licensed under the GNU General Public License v3.0 (GPL)

---

**Found this useful?** consider dropping a [star ⭐](https://github.com/AtharvSan/solidity_cheatsheet) , your support will motivate me to do more such works.

[![Twitter Follow](https://img.shields.io/twitter/follow/AtharvSan?style=social)](https://twitter.com/AtharvSan)
[![GitHub Follow](https://img.shields.io/github/followers/AtharvSan?label=Follow%20me&style=social)](https://github.com/AtharvSan)