// --- part 1 of a 5 part series on essentials for solidity devs ---
// - Essential-Solidity
// - Essential-Cryptography
// - Essential-Assembly
// - Essential-DesignPatterns
// - Essential-Security 


/* table of contents ----------------*/
// - basics
//      - license
//      - pragma
//      - imports
//      - path resolution
//      - contract
//      - events
//      - constructor
//      - receive
//      - modifier
//      - functions
//      - symbols
//      - variables
//      - control sturctures
//      - units
//      - block
//      - msg
//      - tx
// - intermediate
//      - OOPs
//      - library
//      - custom errors
//      - fallback
//      - variable passing
//      - value types
//      - reference types
//      - type conversion
//      - datatype builtins
//      - fringe arithmetic
// - advanced
//      - function signatures and selectors
//      - abi encoding
//      - low level calls
//      - error handling
//      - bit operations
//      - bitmasking


/* license -------------------------*/
// - copyleft: 
//      - ensure that the software is free and open-source even in its derivative versions
//      - you use this when you do open source software and don't want to let someone else make it proprietary
//      - examples: GNU General Public License v3.0 (GPL-3.0)
// - permissive: 
//      - allows the software to be used in proprietary software
//      - you use this when you want maximum adoption with minimal legal overhead
//      - examples: MIT, Apache-2.0, BSD-3-Clause
// - implementaion: SPDX-License-Identifier: licence
//      - Software Package Data Exchange (SPDX)
//      - this licence declaration is directly included in the source code as a commment
// SPDX-License-Identifier : GPL-3.0


/* pragma --------------------------*/
// - ^version: means versions above this but below breaking changes version
// - nothing before the version means just that one version
pragma solidity ^0.8.20;


/* imports -------------------------*/
// - import "filename"; 
//      - imports everything from that file
// - import {symbol1, symbol2} from "filename";
//      - imports only the mentioned items
// - import {symbol1 as alias1, symbol2 as alias2} from "filename";
import "@openzeppelin/token/ERC20/utils/SafeERC20.sol";


// Base contract
contract A {
    function getName() public pure virtual returns (string memory) {
        return "A";
    }
}

// Derived from A
contract B is A {
    function getName() public pure virtual override returns (string memory) {
        return "B";
    }
}

// Derived from A
contract C is A {
    function getName() public pure virtual override returns (string memory) {
        return "C";
    }
}


/// @author AtharvSan
/// @dev Part 1: compilable cheatsheet for solidity devs
// contract
// - create contracts using new, see constructor
// - contract size limit 24kb
// - contract bytecode is deployed onchain (each account has code and codehash section)
contract EssentialSolidity is B, C {
    /* OOPs -----------------------------*/
    // - problem : large codebases are hard to manage
    // - solution : structure code into smaller packets.
    // - implementation 
    //      - components: class, object, method, variables
    //      - is: inherits contracts
    //          - contract A is B,C,D : B is most base, D is most derived
    //          - C3 linearization right to left(D to B) to resolve conflicts in inheritance
    //      - constructor: order of execution from most base to most derived (B to D)
    //      - visibility: public, internal, private, external
    //      - abstract: when a function is missing definition
    //      - super: call parent class definition
    //      - this: the contract itself in which 'this' is invoked(contract type)
    //      - virtual and override: manage polymorphism
    // - properties
    //      - encapsulation: bundling everything to form a fully working entity
    //      - abstraction: only expose what is required, rest is kept enclosed
    //      - inheritance: acquiring properties from parents
    //      - polymorphism: The ability to take multiple forms (method overloading & method overriding)
    // - pros : 
    //      - Code Reusability
    //      - Modularity
    //      - Security & Data Hiding
    //      - Easy Maintenance & Scalability
    // - trivia:
    //      - C3 linearization to resolve inheritance conflicts: inheritance from right to left in the 'is' statement
    function getName() public pure override(B, C) returns (string memory) {
        // Resolves using C3 Linearization
        // in our case method resolution order is: EssentialSolidity -> C -> B -> A
        // so the getName() method of C is called
        return super.getName(); 
    }


    /* library -----------------------------*/
    // - implementation
    //      - cannot have state variables
    //      - functions in library to have the first parameter as the 'datatype' on which to attach the library
    // - libraries can be used in two methods 
    //      - using library for type : attaches library functions to the type
    //      - library.method
    // - trivia:
    //      - cannot inherit, nor be inherited
    //      - inheritance doesnt bring using for statement from parent to child, need to write using for again in child.
    //      - cannot recieve ether
    //      - deployment:
    //          - libraries are deployed only when it contains external functions and called by delegatecall  
    //          - else its code is embedded into the calling contract at compile time
    //      - the calling convention is designed like internal call not following the abi standard
    using SafeERC20 for IERC20; 
    

    /* events ------------------------------*/
    // - has normal params and indexed params(for quick searches)
    // - indexed topics are capped at max 3
    // - trivia:
    //      - Event logs are stored on blockchain but not accessible from within contracts not even from the contract that created them
    //      - indexed are special params included in a seperate place called topics
    //      - 'indexed' arguments make it easy for searching and filtering through the logs
    event Log(string message);
    event newOwner(address indexed owner);


    /* custom errors -----------------------*/
    // - Cheaper gas costs (saves storage compared to string messages)
    // - More structured error messages.
    // - implementation
    //      - error certain_edge_case_messing_up();
    //      - error certain_edge_case_messing_up_explained_with_args(args);
    //      - revert certain_edge_case_messing_up();
    //      - revert certain_edge_case_messing_up_explained_with_args(args);
    error amount_smaller_than_100(uint256 amount);
    function custom_error(uint256 amount) public pure {
        if (amount< 100) {
            revert amount_smaller_than_100(amount);
        }
    }


    /* constructor -------------------------*/
    // - executes once during deployment 
    // - can recieve ether during deployment
    // - its runtime code, not part of the contract
    // - constructor execution order: B -> C -> EssentialSolidity
    //      - most base to most derived
    constructor(/* args1, args2 */) /* B(args1) C(args2) */ payable {
        wingman = new Wingman();
        owner = msg.sender;
        emit newOwner(owner);
    }


    /* fallback ----------------------------*/
    // - called when the contract is invoked with calldata, but function definition is absent
    // - this function has builtin definition and its very strict, only two variations allowed
    // - fallback() external [payable] {}
    // - fallback(bytes calldata input) external [payable] returns(bytes memory) {}
    // - trivia:
    //      - does not have a function signature
    fallback(bytes calldata _shipment) external payable returns(bytes memory){ 
        string memory payload = abi.decode(_shipment,(string));
        return bytes(string.concat(payload, "_done"));
    }


    /* receive -----------------------------*/
    // - this function is called when the contract is invoked without calldata
    // - main purpose is to receive ETH
    // - this function has builtin definition, only one variation allowed
    // - receive() external payable {}
    // - its mostly kept empty
    // - trivia:
    //      - does not have a function signature
    receive() external payable {} 


    /* modifier ----------------------------*/
    // - a piece of code that generally contains some checks and is placed on top of a function
    // - modifiers can accept arguments
    // - function body represented by _ it can be included multiple times.
    // - Modifiers wrap around the function body using the special placeholder _ When multiple modifiers are applied, they execute in a nested manner:
    // - The first modifier runs until it reaches _.
    // - Control moves to the next modifier in the order they are listed.
    // - This continues until the function itself executes.
    // - Once the function completes, execution unwinds back up through the modifiers.
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call this function");
        _;
    }
    modifier single_digit_value(uint256 _value) {
        require(_value < 10, "value should be less than 10");
        _;
    }
    function onlyOwnerFunction(uint256 value) view public onlyOwner single_digit_value(value) returns(string memory) {
        return "greetings to the owner";
    }


    /* functions ---------------------------*/
    // - return variables can be used as any other local variable.
    // - members: .selector 
    // - return: concludes the function execution generally returns some value.


    /* symbols -----------------------------*/
    // - () --> functions, mapping, typecasting
    // - {} --> function blocks, struct blocks, conditional blocks, loop blocks
    // - [] --> arrays
    // - ; --> end of statement
    // - : --> key value pair, array slicing, ternary operator
    // - , --> seperator
    // - . --> access
    // - - --> subtraction
    // - + --> addition
    // - * --> multiplication
    // - / --> division
    // - % --> modulo
    // - ** --> power
    // - || --> or
    // - && --> and
    // - | --> bitwise or
    // - & --> bitwise and
    // - ! --> not
    // - ~ --> bitwise not
    // - ^ --> bitwise xor
    // - << --> left shift
    // - >> --> right shift
    // - == --> equal
    // - != --> not equal
    // - < --> less than
    // - > --> greater than
    // - <= --> less than or equal
    // - >= --> greater than or equal
    // - = --> assignment
    // - += --> addition assignment
    // - _ --> integer filler
    // - "" --> string
    // - '' --> string
    // - \ --> escape character
    // - // --> single line comment
    // - /// --> natspec comment
    // - /* */ --> multi line comment
    // - /**  */ --> multi line natspec comment


    /* variables --------------------------*/
    // - life cycle of a variable
    //    - definition
    //    - declaration
    //    - assignment
    //    - access
    // - attributes
    //    - interpretation
    //    - size
    //    - type
    //    - data location
    //    - slot position
    //    - behaviour
    //    - visibility
    //    - name
    //    - value


    /* variable passing --------------------*/
    // - pass by value: value copy pasted to new location, new variable (copy paste)
    //      --------------       --------------
    //      |    value   |       |    value   |
    //      |------------|       |------------|
    //      |  location1 |       |  location2 |
    //      --------------       --------------
    //         * name1 *            * name2 * 
    //
    // - pass by reference: 
    //      - pass in same data location: nothing is copy pasted, instead a new name is given to the same location value pair (renaming)
    //      - pass in different data location: pass by value
    //      -------------
    //      |   value   |
    //      |-----------|
    //      |  location |
    //      -------------
    //     * name1, name2 * 
    function passByValue(uint256 _amt) public {
        unsigned_integer = _amt;
    }
    function passByReference(string calldata given_name) public {
        mapping(string=>uint256) storage register = table[given_name];
        register["football"] = 1000;
    }


    /* data location ----------------------*/
    // bit level architecture, data location, inline assembly and gas costs covered in assembly cheatsheet.
    // --- memory ---
    // - structure : byte addressable array that reads and writes on 32 byte words
    // - trivia 
    //      - locally available, function scoped
    //      - temporary existence, only for duration of tx
    //      - cheap

    // --- storage ---
    // - structure
    //      - mapping of 32-byte keys(storage-slots) to a 32-byte values
    //      - storage slots start at slot 0
    // - trivia
    //      - globally avilable
    //      - permanent existance
    //      - expensive 

    // --- calldata ---
    // samae as memory, but its read only


    /* value types ----------------------------*/
    // --- uint ---
    // - uint8,...,uint256
    // - uint is uint256
    // - uint are unsigned integers, meaning every bit contributes to the value
    // int 
    // - int8,...,int256
    // - int is int256
    // - int are signed integers, meaning the leftmost bit is the sign bit and rest contribute to the value
    uint256 public unsigned_integer = 1e2; // 1_00 also valid
    int256 public signed_integer = -15;

    // --- fixed arrays (bytesN, fixed arrays) ---
    // - bytes1,...,bytes32
    //      - notice that bytes is not bytes32, instead bytes is bytes[] 
    // - fixed arrays : only member is .length
    //      - definition and declaration
    //          - type[n] arr
    //      - trivia
    //          - multidimentional arrays supported
    //          - you can't get full array from getter functions, you only get individual elements
    //          - variable names are good enough to pass arrays, loops not necessary
    //          - slicing only available in calldata array with offsets that behave mathematically like [start:end) but syntax is [start:end]
    bytes4 public selector = 0x1a1b1c1d;
    bytes8 public selector1 = "1a1b1c1d";
    bytes16 public selector2 = unicode"text";
    bytes32 public hashed = keccak256("cheatsheet"); // hash functions and signatures covered in cryptography cheatsheet
    uint256[3] public fixed_integer_array = [1,2,3];

    // --- addresses ---
    // - address
    //      - 160 bits long
    //      - msg.sender is by default address type (non-payable)
    //      - members: balance, code, codehash, call(), delegatecall(), staticcall()
    // - address payable
    //      - 160 bits long
    //      - members: all of address members and transfer() and send()
    address public owner; 
    address payable public client;

    // --- contract ---
    // - contract type is a combo of address and funtion selectors
    // - contract type does not store the contract bytecode, instead it stores the address and function selectors. 
    // - notice that contract datatype and interface datatype is essentially the same, the only difference is in their definition.
    Wingman public wingman = new Wingman();
    address wingmanAddress = address(wingman);
    function contract_cap_on_address() public {
        wingman = Wingman(wingmanAddress);
    }
    
    // --- interface --- 
    // - interface type is a combo of address and funtion selectors
    // - notice that contract datatype and interface datatype is essentially the same, the only difference is in their definition.
    IWingman public iwingman;
    function interface_cap_on_address() public {
        iwingman = IWingman(wingmanAddress);
    }
    
    // --- bool ---
    bool public flag = true;
    
    // --- enum ---
    // - a uint8 that has symbols representing numbers
    // - [0,255] symbols availabe for enum vars, but generally 3 to 5 symbols are used
    enum Bike{SPLENDER /* 0 */, APACHE /* 1 */, ACTIVA /* 2 */}
    
    // --- custom type --- 
    // - problem: Lack of distinction between logically different values can lead to errors. Mixing token amounts with timestamps both as uint256.
    // - solution: custom types
    // - implementation: 
    //      - type custom_type is underlying_type;
    //      - .wrap() to pack underlying type to custom type
    //      - .unwrap() to unpack custom type to underlying type
    // - use cases:
    //      - enhanced security helps prevent accidental mix-up between logically different values
    //      - improves code readability.
    type Timestamp is uint256;
    Timestamp public deployment_time = Timestamp.wrap(block.timestamp);
    
    // --- function type ---
    // - code injection 
    // - just like data(variables) can be passed into contracts(functions), code(function types) can also be passed into contract(functions)


    /* reference types -------------------------*/
    // - for datatypes of reference types, location must be specified

    // --- struct ---
    // - definition : may be defined outside or inside the contract
    // - initation : anyway you need to typecast it into struct using ()
    //      - direct initialization 
    //      - named initialization is packing key : value pairs in a block { } using , seperator 
    // - access using .
    // - deleting a struct does not free storage, only sets the values to default
    struct Person {
        string name;
        uint256 age;
    }
    Person public Arthur = Person("Arthur", 20);
    
    // --- dynamic arrays (string, bytes, dynamic arrays) ---
    // - bytes :
    //      - raw binary data
    //      - built in methods, .length, .push(member), .concat
    //      - byte indexed
    // - string : 
    //      - string literals(utf-8 characters) are enclosed in quotes (single or double both valid)
    //      - escape characters : some characters escape the string output, these are specially handled to be included in the string literal
    //          - \n   \'   \"   \\   
    //          - these characters are only valid for dynamic arrays
    //      - trivia
    //          - members : .concat()
    //          - cannot be accessed by indexing
    // - dynamic arrays
    //      - definition and declaration
    //          - type[] storage arr
    //          - type[] memory arr = new type[](n)
    //      - trivia 
    //          - variable names are good enough to pass arrays, loops not necessary
    //          - you can't get full array from getter functions, you only get individual elements
    //          - members : .length, .push(member), .pop()
    //          - slicing only available in calldata array with offsets that behave mathematically like [start:end) but syntax is [start:end]
    string public name = "C:users\\AtharvSan : \"Hello\"";
    bytes public about1 = "solidity developer";
    uint256[3] public fixed_list = [11,12,13]; //slices only for calldata payload
    uint256[] public dynamic_list = [21,22,23];
    
    // --- mapping --- 
    // - can be only in storage
    // - mappings cannot store diverging relationship (one to many), so you have to be careful of the relationship you declare in mappings
    // - keys are not stored, instead they are hashed       slot=keccak256(abi.encode(key,mappings​lot))
    // - key needs to be simple - value type, bytes, string
    // - value can be any type
    // - no iteratiors, no lenght
    mapping(string=>mapping(string=>uint256)) public table;


    /* type conversion -----------------------------*/
    // - every datatype has a specified container size
    // - when datatypes are converted, we are changing its properties 
    //      - size
    //      - interpretation
    //          - uint
    //          - bytes
    //          - address
    //          - string
    //          - bool
    //          - enum
    //          - custom
    //      - location : need some notes on variable transfers from one location to another 
    uint256 public amt256 = 1000_000;
    uint128 public amt128;
    bytes32 public Hash = keccak256("msg");
    bytes public data;
    address public alice = address(this);
    string public String = "String";
    bool public success = true;
    enum Division {FIRST, SECOND, THIRD}
    Division public division = Division.FIRST;
    function typeConversions() public {
        /* uint256 ---------------------------------- */
        // integers are left padded/truncated when changing datatype size
        /* uint128 <-- uint256 E */amt128 = uint128(amt256);
        /* uint256 <-- uint128 EI */amt256 = uint256(amt128); amt256 = amt128;
        /* bytes32 <-- uint256 E */Hash = bytes32(amt256);
        /* address <-- uint256 E */alice = address(1000);
        /* enum <-- uint256 E */division = Division(amt256);
        /* string <-- uint256 - (uint256 -> bytes32 -> bytes -> string) */


        /* bytes32 ---------------------------------- */
        // bytes are right padded/truncated when changing datatype size
        /* bytes4 <-- bytes32 E */selector = bytes4(Hash);
        /* uint256 <-- bytes32 E */amt256 = uint256(Hash);
        /* address <-- bytes20 E */alice = address(bytes20(Hash));
        /* bytes <-- bytes32 - (bytes.concat(Hash) returns(bytes)) */
        /* string <-- bytes32 - (bytes32 -> bytes -> string) */


        /* bytes ------------------------------------ */
        /* bytes32 <-- bytes E */Hash = bytes32(data);
        /* bytes4 <-- bytes E */selector = bytes4(data);
        /* string <-- bytes E */ String = string(data);
        /* uint256 <-- bytes - (bytes -> bytes32 -> uint256) */
        /* address <-- bytes - (bytes -> bytes20 -> address) */


        /* string ----------------------------------- */
        /* bytes <-- string E */data = bytes(String);
        /* bytes32 <-- string - (string -> bytes -> bytes32)*/ 
        /* uint256 <-- string - (string -> bytes -> bytes32 -> uint256)*/
        /* address <-- string - (string -> bytes -> bytes20 -> address)*/


        /* address ---------------------------------- */
        /* address payable <-- address E */ address payable bob = payable(alice);
        /* address <-- address payable EI */ alice = address(bob); alice = bob;
        /* bytes20 <-- address E */bytes20 shortHash = bytes20(alice);
        /* uint256 <-- address - (address -> bytes20 -> bytes32 -> uint256)*/
        /* string <-- address - (address -> bytes20 -> bytes.concat() returns(bytes) -> string) */


        /* address, contract and interface ---------- */
        /* contract <-- address E */ wingman = Wingman(wingmanAddress);
        /* interface <-- address */ iwingman = IWingman(wingmanAddress);
        /* address <-- contract E */ wingmanAddress = address(wingman);
        /* address <-- interface */ wingmanAddress = address(iwingman);
        /* interface <-- contract - (contract -> address -> interface)*/ 
        /* contract <-- interface - (interface -> address -> contract)*/


        /* enum ------------------------------------- */
        /* uint256 <-- enum E */amt256 = uint256(Bike.SPLENDER);
    }


    /* datatype builtins -----------------------------*/
    // - address
    //      - balance
    //      - code : the bytecode of the contract
    //      - codehash : the hash of the bytecode 
    //      - call()
    //      - delegatecall()
    //      - staticcall()
    // - address payable : all of address and these two
    //      - transfer(): sends ether to the address, reverts on failure, 2300 fixed gas(not recommended)
    //      - send(): sends ether to the address, returns false on failure, 2300 fixed gas(not recommended)
    // - contract
    //      - public and external functions 
    // - fixed custom arrays
    //      - length
    // - dynamic custom arrays
    //      - length
    //      - push()
    //      - pop()
    // - bytes
    //      - length
    //      - push()
    //      - pop()
    //      - concat()
    // - string
    //      - concat()
    // - custom types
    //      - wrap()
    //      - unwrap()


    // type information -------------------------//
    // - type(C).name : the name of the contract
    // - type(C).creationCode : creation bytecode of the given contract
    // - type(C).runtimeCode : runtime bytecode of the given contract
    // - type(I).interfaceId : value containing the EIP-165 interface identifier of the given interface
    // - type(T).min : the minimum value representable by the integer type T
    // - type(T).max : the maximum value representable by the integer type T


    /* fringe arithmetic -------------------------*/
    // increment decrement operators
    // - a++ and a-- return then update, ++a and --a update then return
    function increment_and_get_values() pure public returns(uint256 a, uint256 b, uint256 c) {
        a = 10;
        b = a++; // b = 10, a = 11
        c = ++a; // c = 12, a = 12
    }

    // --- unchecked arithmetic ---
    // - arithmetic operations in Solidity are checked by default, meaning they will throw an error if the result is out of bounds.
    // - unchecked { ... } block to bypass the check
    function unchecked_addition() pure public {
        unchecked {
            uint8 x = 255;
            x++;
        }
    }

    // --- floating points ---
    // - Solidity doesn’t support floating-point numbers, so devs use scaled integers to approximate decimals.
    // - Multiply by a large constant (e.g., 1e18 for 18 decimal precision).
    // - Perform all operations at the scaled level.
    // - Divide at the end to get the final result.

    // --- rounding ---
    // - integer division in solidity rounds to floor by default
    // - round up (a+b-1)/b
    // - round to nearest (a+b/2)/b
    
    // --- negative integers ---
    int256 public y = -15;
    
    // --- max values ---
    // - gives you the literal max value that the datatype can hold
    uint256 public bigNumber = type(uint256).max;


    /* control sturctures ----------------------*/
    // --- if else ---
    // - if else is a block of conditions, if a condition is met the control skips out of the block ommiting the rest of the conditions
    // - in a scenario where only if statements are used, then each condition is checked.
    function if_else_block(uint256 input) pure public returns(string memory) {
        if (input == 0) {
            return "zero";
        } else if (input == 1) {
            return "one";
        } else {
            return "more";
        }
    }
    
    // --- ternary operator ---
    // - shorthand for if else
    // - condition ? value_if_true : value_if_false
    function ternary_operator_used_here_to_check_if_input_is_zero(uint256 input) pure public returns(string memory) {
        return input == 0 ? "zero" : "more";
    }
    
    // --- loops ---
    // - special keywords: break, continue
    // - for
    //     - execute the same operation for each iteration
    //     - number of iterations is known
    //     - condition is checked at the start of each iteration
    function sum_of_integers_upto_n_for_loop(uint n) public pure returns (uint) {
        uint total = 0;
        for (uint i = 1; i <= n; i++) {
            total += i;
        }
        return total;
    }

    // - while: number of iterrations is not known but just the condition is known
    function sum_of_integers_upto_n_while_loop(uint n) public pure returns (uint) {
        uint total = 0;
        uint i = 1;
        while (i <= n) {
            total += i;
            i++;
        }
        return total;
    }
    
    // - do while: operation executes atleast once, then condition is checked
    function sum_of_integers_upto_n_doWhile_loop(uint n) public pure returns (uint) {
        uint total = 0;
        uint i = 1;
        do {
            total += i;
            i++;
        } while (i <= n);
        return total;
    }


    /* error handling --------------------------*/
    // - trivia:
    //      - Solidity transactions are atomic, transactions either fully execute or fully fail.
    //      - failure: did not reach return or the last statement in the function.
    //      - success: reached return or the last statement in the function.
    //      - throwing errors: Throwing happens when a contract fails within itself (require, revert, assert)
    //      - bubbling errors: Bubbling occurs when an error from an external contract propagates to the caller.
    // - failures occur when a function does not execute as expected. This could be due to:
    //      - Invalid conditions (require, assert, revert)
    //      - Out-of-gas errors
    //      - Failed external calls
    // - revert : 
    //      - rolls back the transaction, undoing any changes to the state
    //      - implementation: notice that revert executes like a keyword, without paranthesis
    //          - revert;
    //          - revert("message");
    //          - revert custom_error();
    //          - revert custom_error(args);
    // - require : 
    //      - if certain conditions fail, it just reverts
    //      - its like a checkpoint, if everythings all right move ahead, else roll back
    //      - implementation 
    //          - require(condition);
    //          - require(condition, "message");
    // - try-catch block
    //      - handles external calls that give granular control over transaction reverts
    //      - catch doesn't deal with failures from custom errors, need some workaround for that
    //      - use cases
    //          - Preventing transaction failure in multi-step processes
    function safeCall(uint256 x) external view returns (string memory, uint256) {
        try wingman.riskyFunction(x) returns (uint256 result) {
            return ("Success", result); // successful execution of external call
        } catch Error(string memory reason) {
            return (reason, 0); // external call reverts with require msg
        } catch (bytes memory) {
            return ("Reverted with unknown reason", 0); // 
        }
    }
    

    /* function signatures and selectors --------------*/
    // - signature : 
    //      - "guess_my_function_signature(uint256,address,bytes32)"
    //      - signature is a string
    //      - only name and input params matter for signature, rest of the function doesn't impact the signature.
    // - selector : 
    //      - bytes4(keccak256("guess_my_function_signature(uint256,address,bytes32)"))
    //      - selector is a bytes4
    function guess_my_function_signature(uint256 value, address to, bytes32 hash) public pure returns(bool) {
        return true;
    }


    /* abi encoding -----------------------------*/
    // memory, storage, calldata layouts in more detail in assembly cheatsheet
    // --- encode ---
    // - encodes given arguments into ABI-encoded bytes (equivalent to Solidity's calldata encoding).
    // - when there may be potential decode going on somewhere
    function encode() public pure returns(bytes memory){
        return abi.encode("AtharvSan", 1000, true);
    }

    // --- encodePacked ---
    // - abi.encodePacked removes zero padding from packing, different values may result in same final packed value and hence hash collision.
    // - notes : cannot perform packed encoding on a literal, need to convert to a datatype container first.
    function encodePacked() public pure returns(bytes memory){
        string memory nikName = "AtharvSan";
        uint256 netWorth = 10_000;
        bool isRich = true;
        return abi.encodePacked(nikName, netWorth, isRich);
    }

    // --- encodeWithSignature ---
    // - packing calldata for low level calls
    function encodeWithSignature() public pure returns(bytes memory) {
        return abi.encodeWithSignature("extraCode(uint256)", 1000);
    }

    // --- encodeWithSelector ---
    // - packing calldata for low level calls
    function encodeWithSelector() public pure returns(bytes memory) {
        return abi.encodeWithSelector(Wingman.extraCode.selector, 1000);        
    }
    
    // --- encodeCall ---
    // - since Solidity 0.8.11
    // - safer way to encode function calls compared to encodeWithSelector and encodeWithSignature
    // - you just write which function of the contract, it automatically gets the function selector
    function encodeCall() public pure returns(bytes memory) {
        return abi.encodeCall(Wingman.extraCode, (1000));
    }

    // --- decode --- 
    // - decodes ABI-encoded data into the constituting types
    // - mostly used in fallback to unpack the calldata
    function decode(bytes calldata datapack) public pure returns(bytes memory) {
        abi.decode(datapack, (uint256));
    }


    /* low level calls ---------------------------*/
    // --- call ---
    // - moves control into the called contract
    // - returns 'true' even if the address called is non-existent, account existence should be checked prior to call/delegatecall/staticcall
    //      - if address.code.length > 0  // contract exists
    //      - assembly  if extcodesize(address) > 0  // contract exists
    // - need to manually check for success
    // - recieving contract auto executes the called function, bytecode handles everything.
    function lowLevelCall() public returns(string memory) {
        uint256 _value = 1000;
        bytes memory _data = abi.encodeCall(Wingman.extraCode, (_value));
        (bool success_c, bytes memory data_c) = wingmanAddress.call{value: _value}(_data);
        require(success_c, "call failed");
        string memory data_collected_from_wingman = abi.decode(data_c,(string));
        return data_collected_from_wingman;
    }

    // --- delegatecall ---
    // - imports external code to be executed here, context remains the same(the msg components)
    // - since delegatecall, contracts are no longer fixed, code can change
    // - returns 'true' even if the address called is non-existent, account existence should be checked prior to call/delegatecall/staticcall
    // - need to manually check for success
    // - recieving contract auto executes the called function, bytecode handles everything.
    function lowLevelDelegateCall() public returns(string memory) {
        uint256 _value = 1000;
        bytes memory _data = abi.encodeCall(Wingman.extraCode, (_value));
        (bool success_dc, bytes memory data_dc) = wingmanAddress.delegatecall(_data);
        require(success_dc, "delegatecall failed");
        string memory data_collected_from_wingman = abi.decode(data_dc,(string));
        return data_collected_from_wingman;
    }    

    // --- staticcall ---
    // - same as call with one difference, will revert if the called function modifies the state in any way.
    function lowlevelStaticCall() view public returns(string memory) {
        uint256 _value = 1000;
        bytes memory _data = abi.encodeCall(Wingman.extraCode, (_value));
        (bool success_sc, bytes memory data_sc) = wingmanAddress.staticcall(_data);
        require(success_sc, "staticcall failed");
        string memory data_collected_from_wingman = abi.decode(data_sc,(string));
        return data_collected_from_wingman;
    }


    /* bit operations -------------------------*/
    // - problem: gas optimization 
    // - solution: use bitwize operations
    // - implementation: 
    //      - left shift <<
    //      - right shift >>
    //      - OR   |
    //      - AND  &
    //      - XOR  ^
    //      - NOT  ~
    // - trivia
    //              
    //          | 0  0 | 0 |            | 0  0 | 0 |            | 0  0 | 0 |            
    //          | 1  0 | 1 |            | 1  0 | 0 |            | 1  0 | 1 |            
    //          | 0  1 | 1 |            | 0  1 | 0 |            | 0  1 | 1 |            
    //          | 1  1 | 1 |            | 1  1 | 1 |            | 1  1 | 0 |            
    //
    //               OR                     AND                     XOR
    //
    function shiftLeft(uint256 number, uint256 bits) public pure returns (uint256) {
        // 1 << 0 = 0001 --> 0001 = 1
        // 1 << 3 = 0001 --> 1000 = 8
        // 3 << 1 = 0011 --> 0110 = 6
        return number << bits;
    }
    function shiftRight(uint256 number, uint256 bits) public pure returns (uint256) {
        // 1 >> 0 = 0001 --> 0001 = 1
        // 1 >> 3 = 0001 --> 0000 = 0
        // 3 >> 1 = 0011 --> 0001 = 1
        return number >> bits;
    }


    /* bitmasking ---------------------------*/
    // - the problem: how to bring precision at the bit level interaction
    // - the solution: use masks (masks can easily be created using bitshifting)
    // - implementation:
    //      - value: the bit value that we want to deal with
    //      - mask: it is a bit pattern created for a certain use case
    //      - bit operation: OR, AND, XOR
    // - properties
    //      - assign value: OR with value-mask
    //      - extract value: AND with 1-mask
    //      - set a bit: OR with 1-mask
    //      - clear a bit: AND with 0-mask
    //      - toggle a bit: XOR with 1- mask
    // - use cases
    //    - packing smaller datatypes in bigger slots
    function pack(uint128 a, uint128 b) public pure returns (uint256) {
        return (uint256(a) << 128) | uint256(b);
    }
    function unpack(uint256 packed) public pure returns (uint128 a, uint128 b) {
        a = uint128(packed >> 128);
        b = uint128(packed);
    }


    /* units --------------------------------*/
    // - payment : wei, gwei, ether
    // - time : seconds, minutes, hours, days, weeks
    // - trivia : 
    //      - all units in solidity are uint values
    //      - time units are spelled in plural
    uint256 public oneWei = 1 wei; // 1
    uint256 public oneGwei = 1 gwei; // 1e9
    uint256 public oneEther = 1 ether; // 1e18
    uint256 public oneSecond = 1 seconds; // 1
    uint256 public oneMinute = 1 minutes; // 60
    uint256 public oneHour = 1 hours; // 3600
    uint256 public oneDay = 1 days; // 86400
    uint256 public oneWeek = 1 weeks; // 604800


    /* block --------------------------------*/
    function getTime() public view returns(uint256) {
        return block.timestamp;
    }
    function getChainId() public view returns(uint256) {
        return block.chainid;
    }
    function getblockNumber() public view returns(uint256) {
        return block.number;
    }
    function getBaseFee() public view returns(uint256) {
        return block.basefee;
    }
    function getGasLimit() public view returns(uint256) {
        return block.gaslimit;
    }
    function getCoinbase() public view returns(address) {
        return block.coinbase;
    }
    function getPrevRandao() public view returns(uint256) {
        return block.prevrandao;
    }
    function getBlockHash() public view returns(bytes32) {
        return blockhash(block.number);
    }

    /* msg ---------------------------*/
    function getSender() public view returns(address) {
        return msg.sender;
    }
    function getSig() public pure returns(bytes4) {
        return msg.sig;
    }
    function getData() public pure returns(bytes calldata) {
        return msg.data;
    }
    function getValue() public payable returns(uint256) {
        return msg.value;
    }
    function getGas() public view returns(uint256) {
        return gasleft();
    }

    /* tx -----------------------------*/
    function getOrigin() public view returns(address) {
        return tx.origin;
    }
    function getGasPrice() public view returns(uint256) {
        return tx.gasprice;
    }
}

contract Wingman {
    function extraCode(uint256 x) public pure returns (string memory) {
        require(x != 0, "require failed"); //require statements revert
        return "extra code was called";
    }

    function riskyFunction(uint256 x) external pure returns (uint256) {
        require(x > 10, "Value must be greater than 10");
        return x * 2;
    }
}

/* interface ----------------------------*/
// - Interfaces enforce standardization and modularity with clear function signatures and return signatures.
// - interfaces should be correctly implemented (even the return values) wrt EIPs.
// - trivia
//      - cannot have state
//      - cannot have function implementations
//      - all functions must be external
//      - functions declared in interfaces are implicitly 'virtual'
//      - type(I).interfaceId: A bytes4 value containing the EIP-165 interface identifier of the given interface I.
interface IWingman {
    function extraCode(uint256 x) external pure returns (string memory);
}