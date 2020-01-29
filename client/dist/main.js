"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var crypto_ts_1 = require("crypto-ts");
function hello(compiler) {
    console.log("Hello from " + compiler);
}
function getHash(message) {
    console.log("Plain message " + message);
    var messageHash = crypto_ts_1.SHA256("Edgar");
    console.log("Hash of message: " + messageHash);
    var nombre = 'Edgar';
    console.log("Nombre: " + nombre);
}
hello('TypeScript');
getHash('Edgar');
