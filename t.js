var numberOfSteps = function(num) {
    let modulo = num % 2 === 0 ;
    let res = 0;
    for(let i = 0; i <=num; i++){
        if(modulo){
            res = num / 2 
        }else{
            res = num - 1
        }
    }
    console.log(res);
    return res
};

numberOfSteps(14);