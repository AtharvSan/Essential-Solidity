# Essential-Solidity (1/5) 

[![Solidity 0.8.20](https://img.shields.io/badge/Solidity-0.8.20-363636?logo=solidity)](https://soliditylang.org)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.html)
![GitHub Repo stars](https://img.shields.io/github/stars/AtharvSan/Solidity)


Solidity docs can be overwhelming, if you want something short, Essential-Solidity is exactly that. Its everything that you need with Clear Crisp and Consice notes supported by examples that compile. Now keep all your nuanced learnings stacked up in one place.

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
  git clone https://github.com/AtharvSan/Essential-Solidity.git
  cd Solidity
  forge install
  forge compile
```
### remix 
just copy the code from src/Solidity.sol into remixIDE and you can start playing around.

## Roadmap
Part 1 of a 5 part series on essentials for solidity devs
- Essential-Solidity
- Essential-Cryptography
- Essential-Assembly
- Essential-designPatterns
- Essential-security

## FAQ

**How is this different from Solidity docs?**  
Solidity docs can be overwhelming, if you want something short, Essential-Solidity is exactly that. Its everything that you need with Clear Crisp and Consice notes supported by examples that compile.

**Can I contribute?**
Yes, Contributors are welcome.

**Where are notes on security and other important topics?**
Check Roadmap, I am organizing notes in seperate repos.



## License
This project is licensed under the GNU General Public License v3.0 (GPL)

---

**Found this useful?** consider dropping a [star ⭐](https://github.com/AtharvSan/Solidity) , your support will motivate me to do more such works.

[![Twitter Follow](https://img.shields.io/twitter/follow/AtharvSan?style=social)](https://twitter.com/AtharvSan)
[![GitHub Follow](https://img.shields.io/github/followers/AtharvSan?label=Follow%20me&style=social)](https://github.com/AtharvSan)