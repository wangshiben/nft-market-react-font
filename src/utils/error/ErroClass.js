import ErrorEnum from "./ErrorEnum";
class ErrorClass extends Error {
    constructor(errorCode, reason) {
        super(reason)
        this.ErroCode = errorCode
    }
    static createError(ErrorEnums){
        if (typeof ErrorEnums===typeof ErrorEnum)
            return new ErrorClass(ErrorEnums.code,ErrorEnums.message)
        else return new ErrorClass(ErrorEnum.InvalidErrorType.code,ErrorEnum.InvalidErrorType.message)
    }

}


export default ErrorClass;
