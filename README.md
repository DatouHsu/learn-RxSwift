# RxSwift 學習心得 (持續更新中)

> 有什麼問題都歡迎提出糾正、討論。肛溫

## MVVM
**誕生的原因：** 平常Apple推導的MVC架構非常容易讓大家把code都寫在Controller底下，造成controller對比View、Model異常肥大，才有了傳說中的Massive Controller的稱號.

**MVVM介紹：**
MVVM分別是 View、ViewModel、Model.

`View`: 通常都是Image、Button等常見元件組成，在這裡並不會出現任何有關邏輯、狀態轉換相關的code.
`Model`: 就是資料的集合亦或者是從Server Side取得的資料.

最理想的設計就是當`Model`裡面的資料有變化的時候，`View`的狀態就直接跟著轉變。
但世界上應該沒這麼方便的事情，Model的資料不一定可以直接套用在View上，所以會需要一個中間層來協助資料的串接.

而這時候`ViewModel`的職責就如同名字上所示，是將View跟Model綁起來，如下圖所示，MVC的Controller已經包含在View底下. View跟ViewModel之間透過Controller來實現`綁定`這個動作.

在這裡的`Controller`的工作就會相對單純，只需要負責呈現View相關的Code (比如tableView Delegate 跟 DataSource相關的程式)、以及上述的進行跟ViewModel之間的**綁定(bind)**

> Hint: 一般來說，進行`綁定`的動作會透過Reactive Programming的方式比較直接 (ex. ReactiveCocoa、ReactiveSwift、RxSwift)

![](/image/image1.png)

MVVM的大原則就是將原本在ViewController的`View顯示邏輯`，`驗證邏輯`，`網絡請求`等存放於ViewModel中, 盡量去避免所謂`Massive Controller`發生. 讓邏輯判斷等只有在ViewModel底下發生, 外界只需要領取結果即可.

ViewModel之於View、Model有點像是一個BlackBox, 只需要知道`將值輸入`、`接收改變後的值`	即可，並不需要去知道ViewModel做了什麼事情.

好處：可以將Controller輕量化、將職責分得更清楚、方便測試（還在感受中...）


## 進入RxSwift的世界
### RxSwift
Rx (Reactive Extension 的縮寫)，建議初學還是看官方的 [Getting Start](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md#creating-an-observable-that-performs-work) 體悟才會深，小弟也是一點一點的看慢慢領悟

### 什麼是 Observable & Observer
在正式使用RxSwift之前想先大概介紹一下什麼是`Observable`跟`Observer`. 

首先提一下之前某篇文章舉的例子, 假設現在有一個小孩在房間裡睡覺, 當他醒來開始哭鬧的時候, 大人聽到哭聲就會跑到房間做相對應的事情. 在這裡小孩就是`Observable`，大人是 `subscribe Obsrvable` 的訂閱者，哭鬧則是`事件`, 事件不一定只有一個，小孩哭的原因很多，如果是`肚子餓事件`可能就交給媽媽餵奶，`換尿布事件`可能就交給爸爸換，每個Observer都負責不一樣的事情。

將這概念套回到RxSwift中，一個`被觀察者`可以被很多的`觀察者`訂閱，就像是爸爸媽媽關注自己的小孩一樣，而小孩的狀態會一直隨著時間而有不一樣的變化，所以我們可以產生下面這張圖，橫軸可以想像成時間，時間是由左往右移動，上面這些圓圈就是所謂的事件。

![](/image/sequence.png)

> Hint: 在RxSwift的世界中, Observable會產生所謂的事件, 當Observer訂閱之後, 就會針對收到的事件進行動作. 上圖中的箭號也俗稱為`Sequences`

#### Observable
顧名思義就是一個`可被觀察`的, 有點像是iOS裡面就發射一個 Notification，當監聽這個 Notification的人（Observer）就會有所反應。
比如說View上面有一個TextField，並且是一個Observable，當每輸入一個字的時候，就會發送一個事件給Observer說目前的TextField的text值為何。

Observable會產生三種事件 `onNext`，`onCompleted`，`onError`. 分別代表著：

* onNext(Element): 繼續事件，ex. 在textField上輸入一個 "A" onNext事件就會傳送 "A" 給 Observer.
* onCompleted: 完成事件，當onCompleted事件送出之後，就不會再傳送任何 `onNext`.
* onError(ErrorType): 錯誤事件，發生意外之後也會中斷事件發送.

> Hint: onNext 跟 onError 都可以夾帶進一步的信號內容

在RxSwift中也可以[自行產生Observable](http://adamborek.com/creating-observable-create-just-deferred/).
```
return Observable.create { observer in 
	self.someAsyncOpertation { success: Bool in 
		if success {
			observer.onNext(()) //It sends a void into the AnyObserver<Void>
			observer.onCompleted()
		} else {
			observer.onError(MyError())
		}
	}
	return Disposables.create()
}
```

#### Observer
觀察者，每個 observer 要 implement `ObserverType Protocol`，這個 protocol 只有一個任務 `func on(event: Event<E>)`

#### `<Observable.subscibe>` (ObservableType.subscribe)
ObservableType 中的 subscribe method 負責把任何變化的訊息傳遞給 `Observer`

**Hot Observables vs Cold Observables：**

冷熱信號的概念源於C#的MVVM框架Reactive Extensions中的Hot Observables和Cold Observables

`Hot Observables`和`Cold Observables`的區別：

1. `Hot Observables`是主動的，儘管你並沒有訂閱事件，但是它會時刻推送，就像鼠標移動；
而`Cold Observables`是被動的，只有當你訂閱的時候，它才會發布消息。
2. `Hot Observables`可以有多個訂閱者，是一對多，集合可以與訂閱者共享信息；
而`Cold Observables`只能一對一，當有不同的訂閱者，消息是重新完整發送。

> Hint: 任何的信號轉換即是對原有的信號進行訂閱從而產生新的信號

#### Driver vs Observable
根據 RxSwift 官方的資料，`Driver`也是一種Observable，跟一般的Observable差異在於以下三點：

1. Can't error out
2. Observe on main scheduler
3. Sharing side effects (shareReplayLatestWhileConnected) -> 類似 shareReplay(1)

另外還有一些差異邊看文章邊記錄到的，例如：Observable 是 class， Driver是struct，且Driver内部持有一个Observable。Driver本身沒有像Observable有`create()` method.
因為Driver的特性，所以大部分的人都會利用Driver來實作跟**UI變化**有關係的事情。

#### Subject
在ReactiveX的一些實現中，它既可以當作`observer`也可以當做`Observable`。

因為它是一個observer，所以它可以訂閱一個或多個Observable，同時因為它是一個Observable，它可以傳遞它觀察到的事件，重新發送他們，它也可以發送新的事件。

RxSwift文件提到的有下列三種Subject:

* **PublishSubject:** `Next` 事件只會發送給當前已經訂閱這個subject的Observer，新的Observer不會收到訂閱之前發送的事件。

![](/image/PublishSubject.png)

ex.

```
let subject = BehaviorSubject<String>(value: "Hello RxSwift")

_ = subject.subscribe(onNext: {
    print("Hello World 1")
})

subject.onNext("!!!!!!!!")
```

使用風險：在Subject被創建後到有Observer訂閱它之前這個時間段內，一個或多個數據可能會丟失。如果要確保來自原始Observable的所有數據都被分發話，可以在Create創建Observable時手動給它引入 `cold Observable`的行為（當所有觀察者都已經訂閱時才開始發射數據

* **BehaviorSubject:**
當`Observer`訂閱BehaviorSubject時，它開始發射原始Observable最近發射的數據（如果此時還沒有收到任何數據，它會發射一個default值），然後繼續發射其它任何來自原始Observable的數據。

![](/image/BehaviorSubject.png)

* **ReplaySubject:** 會發射所有來自原始Observable的`所有數據`給`新的Observer`，無論它們是何時訂閱的。 (一種什麼都給你的fu

![](/image/ReplaySubject.png)

> Hint: ReplaySubject的行為和BehaviorSubject類似，都會給Observer發送歷史消息。不同地方有兩點：

> * ReplaySubject沒有默認消息，訂閱空的ReplaySubject不會收到任何消息
> * ReplaySubject自帶一個緩衝區，當有Observer訂閱的時候，它會向Observer發送緩衝區內的所有消息

#### Variable [Deprecated]
##### 請愛用 BehaviorRelay
Variable 為BehaviorSubject的封裝，所以在初始化的時候也必須 init 一個初始值。但是 Variable 沒有 on 系列方法，只提供了 value 屬性。直接對 value 進行 set 等同於調用了 onNext 方法。另外還有一點就是 Variable 不會發射 error 事件。

> Hint: 在 Variable 被dispose時會調用發射 completed 給 Observer 。
> 在 RxSwift 4 中已無法使用. [ref](https://github.com/ReactiveX/RxSwift/blob/master/RxSwift/Deprecated.swift#L170)

ex.

```
//在訂閱 Variable 時，我們無法直接調用 subscribe，需要先調用 asObservable
	
let variable = Variable(1)
variable.asObservable()
	.subscribe { (event) in
        print("Event: \(event).")
}
variable.value = 2
```

既然 Variable 只是 BehaviorSubject封裝，那該怎麼選擇使用的時機？
[BehaviorSubject vs Variable vs other subjects](https://github.com/ReactiveX/RxSwift/issues/487) 關於這個討論可以參考連結！

#### BehaviorRelay：

在使用上很類似於之前的 Variable. 可以直接 subscribe 來使用.
但是請記得要 `import RxCocoa`, 因為 BehaviorRelay.swift 是存在於 RxCocoa 裡面.

透過 accept() method 對 BehaviorRelay 的值進行修改.
 
##### accept(_ event: Element)
```
// Accepts `event` and emits it to subscribers
public func accept(_ event: Element) {
    _subject.onNext(event)
}
```
我們可以透過 BehaviorRelay 的 value 來取得當下的值.
> value 是 read only, 不能被強塞值給 value 一定只能透過上面的 accept() method

##### value
```
/// Current value of behavior subject
public var value: Element {
    // this try! is ok because subject can't error out or be disposed
    return try! _subject.value()
}
```

**example：**

```
let behaviorRelay = BehaviorRelay(value: "Test")
behaviorRelay.asObservable().subscribe { (text) in
	print("\(text)")
}.disposed(by: xxxxx)

behaviorRelay.accept("qqq")
print("\(behaviorRelay.value)")

behaviorRelay.accept(behaviorRelay.value + "wwww")
```

#### DisposeBag：
從字面上來看，他就是一個袋子。 他是個有著類似於 ARC 的機制的類別. 把Observable Observer都放進袋子裡面.

##### 自動釋放
在一般情況下，系統會自己釋放DisposBag中的東西。調用時機會是，假設一個ViewController要被release掉時，該controller底下的disposBag也會觸發deinit的method。

##### 手動釋放
如果不想要等到 disposeBag 所在物件的生命週期結束才釋放，可以選擇手動將原本的 disposeBag 替換成新的 instance 即可：

```
self.disposeBag = DisposeBag()
```

目前官方建議的寫法是:

```
.disposed(by: disposeBag)
```

### UIBindingObserver
使用RxSwift開發的時候，一定會需要 import Rxswift，另一個很重要的就是 import RxCocoa，RxCocoa 是Rx團隊針對 Cocoa 所實做的Rx Extension，所以以下這一行才會成立！

```
texttextField.rx.text.subscribe(onNext: { text in
	// Do some things with text
}).disposed(by: cell.disposeBag)
```

但是一定會有RxCocoa的Extension不好用，或是想要讓自訂的Class也享受Rx的功能。 這時候就可以考慮 Extension UIBindingObserver.

ex. 
```
extension Reactive where Base: UITextField {
	var textFieldEnable: UIBindingObserver<Base, Result> {
		return UIBindingObserver(UIElement: base) { textFiled, result in
	   		textFiled.isEnabled = result.isValid
	   }
	}
}
```
Extension之後就可以使用 `xxxx.bin(to:myTextField.rx.textFieldEnable)`. 就可以很方便地把`viewModel`跟`View` bind在一起

### **常用的Operator**
* binTo: 等同於 `Subscribe`
* shareRply (看情況用 能不用就不要亂用)
* map: 轉換型別
* flatMapLatest: 通常用在可能會中斷的事件，可以把事件重新接上，像是打 `API`
* skip: 用來忽略開頭的事件
* filter: 過濾非必要的事件
* combineLatest: 彙整多個Observable，通常拿來驗證多欄位資料時
* observeOn: 可以設定要在哪個 `queue`. 像是 main queue

**..to be continue**


### RxSwift Community
- [RxSwift Community](https://github.com/RxSwiftCommunity): 想多了解RxSwift還有哪些人家寫好的rxtension library 可以來這裡番
- [NSObject-Rx](https://github.com/RxSwiftCommunity/NSObject-Rx): 如果覺得一直宣告`disposeBag`很麻煩的話，可以考慮import這個.
- [RxSwiftExamples](https://github.com/DroidsOnRoids/RxSwiftExamples)

### 巨人們 (我站在他們的肩膀看RxSwift):
* [ReactiveX/RxSwift.github](https://github.com/ReactiveX/RxSwift)
* [Thinking in RxSwift](http://adamborek.com/rxswift-materials-list/)
* [RxMarbles](http://rxmarbles.com/)
* https://academy.realm.io/posts/slug-max-alexander-mvvm-rxswift/?
* https://coderwall.com/p/vti_8w/rxswift-learning-resources
* https://www.teehanlax.com/blog/model-view-viewmodel-for-ios/


### Recommand Vedio on Youtube:ˇ
* [RxSwift: Deep Cuts](https://www.youtube.com/watch?v=Y5Noc7FC1b8)
* [RxSwift in Practice](https://www.youtube.com/watch?v=W3zGx4TUaCE) 