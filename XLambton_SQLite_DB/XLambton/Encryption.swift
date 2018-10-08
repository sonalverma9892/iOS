//
//  Encryption.swift
//  XLambton
//
//  Created by Sonal Verma on 2018-08-09.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import Foundation

class Encryption {
    
    init(){
        
    }
    
    //ENcryption
    func encrypt(value: String) -> String{
        var con: String = ""
        let arrayofstring = Array(value.characters)
        print(arrayofstring)
        
        for value in arrayofstring{
            print(value)
            switch value {
            case "a","A":
                con += "2" + "|"
            case "b","B":
                //            return String(3)
                con += "3" + "|"
            case "c","C":
                con += "5" + "|"
            case "d","D":
                con += "7" + "|"
            case "e","E":
                con += "11" + "|"
            case "f","F":
                con += "13" + "|"
            case "g","G":
                con += "17" + "|"
            case "h","H":
                con += "19" + "|"
            case "i","I":
                con += "23" + "|"
            case "j","J":
                con += "29" + "|"
            case "k","K":
                con += "31" + "|"
            case "l","L":
                con += "37" + "|"
            case "m","M":
                con += "41" + "|"
            case "n","N":
                con += "43" + "|"
            case "o","O":
                con += "47" + "|"
            case "p","P":
                con += "53" + "|"
            case "q","Q":
                con += "59" + "|"
            case "r","R":
                con += "61" + "|"
            case "s","S":
                con += "67" + "|"
            case "t","T":
                con += "71" + "|"
            case "u","U":
                con += "73" + "|"
            case "v","V":
                con += "79" + "|"
            case "w","W":
                con += "83" + "|"
            case "x","X":
                con += "89" + "|"
            case "y","Y":
                con += "97" + "|"
            case "z","Z":
                con += "101" + "|"
            case "1":
                con += "A" + "|"
            case "2":
                con += "C" + "|"
            case "3":
                con += "E" + "|"
            case "4":
                con += "G" + "|"
            case "5":
                con += "I" + "|"
            case "6":
                con += "K" + "|"
            case "7":
                con += "M" + "|"
            case "8":
                con += "O" + "|"
            case "9":
                con += "Q" + "|"
            case "0":
                con += "S" + "|"
            case " ":
                con += "#" + "|"
            case "@":
                con += "$" + "|"
            case ".":
                con += "!" + "|"
            case "/":
                con += "/" + "|"
            default:
                print( "Not a valid day")
            }
        }
        return con
    }
    
    //Decryption
    func decrypt(_ value: String) -> String{
        var decryptedData: String = ""
        var countryElement:[String] = []
        let stringToSeparate = value.components(separatedBy: "-")
        //        let arrayofstring = Array(value.characters)
        print(stringToSeparate)
        
        for index in stringToSeparate{
            countryElement = index.components(separatedBy: "|")
            
            print(countryElement)
            
            for index in countryElement{
                //index.append(" ")
                //decryptedData += " "
                print(index)
                switch index {
                case "2":
                    decryptedData += "a"
                case "3":
                    decryptedData += "b"
                case "5":
                    decryptedData += "c"
                case "7":
                    decryptedData += "d"
                case "11":
                    decryptedData += "e"
                case "13":
                    decryptedData += "f"
                case "17":
                    decryptedData += "g"
                case "19":
                    decryptedData += "h"
                case "23":
                    decryptedData += "i"
                case "29":
                    decryptedData += "j"
                case "31":
                    decryptedData += "k"
                case "37":
                    decryptedData += "l"
                case "41":
                    decryptedData += "m"
                case "43":
                    decryptedData += "n"
                case "47":
                    decryptedData += "o"
                case "53":
                    decryptedData += "p"
                case "59":
                    decryptedData += "q"
                case "61":
                    decryptedData += "r"
                case "67":
                    decryptedData += "s"
                case "71":
                    decryptedData += "t"
                case "73":
                    decryptedData += "u"
                case "79":
                    decryptedData += "v"
                case "83":
                    decryptedData += "w"
                case "89":
                    decryptedData += "x"
                case "97":
                    decryptedData += "y"
                case "101":
                    decryptedData += "z"
                case "A":
                    decryptedData += "1"
                case "C":
                    decryptedData += "2"
                case "E":
                    decryptedData += "3"
                case "G":
                    decryptedData += "4"
                case "I":
                    decryptedData += "5"
                case "K":
                    decryptedData += "6"
                case "M":
                    decryptedData += "7"
                case "O":
                    decryptedData += "8"
                case "Q":
                    decryptedData += "9"
                case "S":
                    decryptedData += "0"
                case "#":
                    decryptedData += " "
                case "$":
                    decryptedData += "@"
                case "!":
                    decryptedData += "."
                case "":
                    decryptedData += " "
                default:
                    print( "Not a valid day")
                }
            }
        }
        return decryptedData
    }
    
    
}

