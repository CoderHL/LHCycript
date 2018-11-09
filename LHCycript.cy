(function(exports){

	var invalidParamStr = 'Invalid parameter';
	var missingParamStr = 'Missing parameter';

	//bundleid
	LHAppId = [NSBundle mainBundle].bundleIdentifier;
	//根控制器
	LHRootVc = function(){
		return UIApp.keyWindow.rootViewController;
	};
	//document
	LHDocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
	//caches
	LHCachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]; 
	//mainBundlePath
	LHAppPath = [NSBundle mainBundle].bundlePath;

	//加载系统动态库
	LHLoadFramework = function(name){
		var head = "/System/Library/";
		var foot = "Frameworks/"+name+".framework";
		var bundle = [NSBundle bundleWithPath:head + foot] || [NSBundle bundleWithPath:head + "Private" + foot];
		[bundle load];
		return bundle;
	};
	//主窗口
	LHKeyWindow = function(){
		return UIApp.keyWindow;
	};
	//找到显示在最前面的控制器
	var _LHFrontVC = function(vc){
		if (vc.presentedViewController) {
			return _LHFrontVC(vc.presentedViewController);
		}else if ([vc isKindOfClass:[UITabBarController class]]) {
			return _LHFrontVC(vc.selectedViewController);
		}else if ([vc isKindOfClass:[UINavigationController class]]) {
			return _LHFrontVC(vc.visibleViewController);
		}else{
			var count = vc.childViewControllers.count;
			for (var i = count - 1; i >= 0; i--) {
				var childVC = vc.childViewControllers[i];
				if (childVC && childVC.view.window) {
					vc = _LHFrontVC(childVC);
					break;
				}
			}
			return vc;
		}
	};

	LHFrontVC = function(){
		return _LHFrontVC(UIApp.keyWindow.rootViewController);
	};

	LHPointMake = function(x, y){
		return {0:x, 1:y};
	};

	LHSizeMake = function(w, h){
		return {0:w, 1:h};
	};

	LHRectMake = function(x, y, w, h){
		return {0:LHPointMake(x,y), 1:LHSizeMake(w, h)};
	};

	//递归打印controller的层级结构
	LHChildVCs = function(vc){
		if ([vc isKindOfClass:[UIViewController class]])  throw new Error(invalidParamStr);
		return [vc _printHierarchy].toString();
	};
	//递归打印view的层级结构
	LHSubviews = function(view) {
		if (![view isKindOfClass:[view isKindOfClass:[UIView class]]]) throw new Error(invalidParamStr);
		return view.recursiveDescription().toString();
	};
	//判断是否是字符串 "str" @"str"
	LHIsString = function(str){
		return typeof str == 'string' || str instanceof String;
	};
	//判断是否为数组 [] @[]
	LHIsArray = function(array){
		return array instanceof Array;
	};
	//判断是否为数字1 @1
	LHIsNumber = function(num){
		return typeof num == 'number' || num instanceof String;
	};

	var _LHClass = function(className){
		if(!className) throw new Error(missingParamStr);
		if (LHIsString(className)) {
			return NSClassFromString(className);
		}
		if (!className) throw new Error(invalidParamStr);
		//对象或类
		return className.class();
	};

	//打印所有子类
	LHSubclasses = function(className, reg){
		className = _LHClass(className);
		return [c for each (c in ObjectiveC.classes)
		if (c != className && class_getSuperclass(c) && [c isSubclassofClass:className] && (!reg || reg.test(c)))
		]
	};

	//打印所有方法
	var _LHGetMethods = function(className, reg, clazz) {
		className = _LHClass(className);

		var count = new new Type('I');
		var classObj = clazz ? className.constructor : className;
		var methodList = class_copyMethodList(classObj, count);
		var methodsArray = [];
		var methodNamesArray = [];
		for(var i = 0; i < *count; i++) {
			var method = methodList[i];
			var selector = method_getName(method);
			var name = sel_getName(selector);
			if (reg && !reg.test(name)) continue;
			methodsArray.push({
				selector : selector, 
				type : method_getTypeEncoding(method)
			});
			methodNamesArray.push(name);
		}
		free(methodList);
		return [methodsArray, methodNamesArray];
	}	

	var _LHMethods = function(className,reg,clazz){
		return _LHGetMethods(className,reg,clazz);
	}	

	//打印所有的方法名字
	var _LHMethodNames = function(className,reg,clazz)	{
		return _LHMethods(className,reg,clazz)[1];
	}

	//打印所有的对象方法
	LHInstanceMethods = function(className,reg)
	{
		return _LHMethods(className,reg);
	}

	//打印所有的对象方法名字
	LHInstanceMethodNames = function(className,reg)
	{
		return _LHMethodNames(className,reg);
	}

	//打印所有类方法
	LHClassMethods = function(className,reg)
	{
		return _LHMethods(className,reg,true);
	}

	//打印所有类方法的名字
	LHClassMethodNames = function(className, reg){
		return _LHMethodNames(className, reg, true);
	}

	//打印所有成员变量
	LHIVars = function(obj, reg){
		if (!obj) throw new Error(missingParamStr);
		var x = {};
		for(var i in *obj){
			try{
				var value = (*obj)[i];
				if (reg && !reg.test[i] && !reg.test(value)) continue;
				x[i] = value;
			}catch(e){}
		}
		return X;
	}

	//打印所有成员变量的名字
	LHIvarNames = function(obj,reg){
		if (!obj) throw new Error(missingParamStr);
		var array = [];
		for(var name in *obj){
			if (reg && !reg.test(name)) continue;
			array.push(name);
		}
		return array;
	}

})(exports)




