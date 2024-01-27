function isAddress(addressStr){
    let ethereumAddressRegex = /^(0x)?[0-9a-fA-F]{40}$/;
    return ethereumAddressRegex.test(addressStr);

}

function addressExamine(...args){
    for (let i = 0; i < args.length; i++) {
        if (!isAddress(args[i]))return false;
    }
    return true
}

export {addressExamine}
