import ErrorClass from "./ErroClass";

class ErrorEnum {
    constructor(message, code) {
        this.message = message;
        this.code = code;
    }
    getError(){
        return new ErrorClass(this)
    }
    static InvalidErrorType = new ErrorEnum("you have input error enum",0)
    static InvalidAddress = new ErrorEnum("you have invalid input string in type of address", 1);

}

export default ErrorEnum;
