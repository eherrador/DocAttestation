import { SHA256 } from "crypto-ts";

function hello(compiler: string) {
    console.log(`Hello from ${compiler}`);
}

function getHash(message: string) {
    console.log(`Plain message ${message}`);
    var messageHash = SHA256("Edgar");
    console.log(`Hash of message: ${messageHash}`);
    var nombre = 'Edgar';
    console.log(`Nombre: ${nombre}`);
}

hello('TypeScript');
getHash('Edgar');