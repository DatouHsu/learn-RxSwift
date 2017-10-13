# RxSwift 學習心得 (持續更新中)

> 有什麼問題都歡迎提出糾正、討論。肛溫

## MVVM
**誕生的原因：**平常Apple推導的MVC架構非常容易讓大家把code都寫在Controller底下，造成controller對比View、Model異常肥大，才有了傳說中的Massive Controller的稱號.

**MVVM介紹：**
MVVM分別是 View、ViewModel、Model.
View: 通常都是Image、Button等常見元件組成，在這裡並不會出現任何有關邏輯、狀態轉換相關的code.
Model: 就是資料的集合.

最理想的設計就是當Model裡面的資料有變化的時候，View的狀態就直接跟著轉變。但世界上應該沒這麼方便的事情，Model的資料不一定可以直接套用在View上，所以會需要一個中間層來協助資料的串接.

`ViewModel`的職責就如同名字上所示，是將View跟Model綁起來，如下圖所示，MVC的Controller已經包含在View底下. View跟ViewModel之間透過Controller來實現`綁定`這個動作.

在這裡的`Controller`的工作就會相對單純，只需要負責呈現View相關的Code (比如tableView Delegate 跟 DataSource相關的程式)、以及上述的進行跟ViewModel之間的綁定

> Hint: 一般來說，進行`綁定`的動作會透過Reactive Programming的方式比較直接 (ex. ReactiveCocoa、ReactiveSwift、RxSwift)

![](/Users/datou/Documents/Datou/onlyRxSwift/image/image1.png)

MVVM的大原則就是將原本在ViewController的`View顯示邏輯`，`驗證邏輯`，`網絡請求`等存放於ViewModel中, 盡量去避免所謂`Massive Controller`發生. 讓邏輯判斷等只有在ViewModel底下發生, 外界只需要領取結果即可.

ViewModel之於View、Model有點像是一個BlackBox, 只需要知道`將值輸入`、`接收改變後的值`	即可，並不需要去知道ViewModel做了什麼事情.

好處：可以將Controller輕量化、將職責分得更清楚、方便測試（還在感受中...）


## 進入RxSwift的世界

### 什麼是 Observable & Observer
在正式使用RxSwift之前想先大概介紹一下什麼是Observable跟Observer. 

首先提一下之前某篇文章舉的例子, 假設現在有一個小孩在房間裡睡覺, 當他醒來開始哭鬧的時候, 大人聽到哭聲就會跑到房間做相對應的事情. 在這裡小孩就是`Observable`，大人是`Observer`，哭鬧則是`事件`, 那事件不一定只有一個，小孩哭的原因很多，爸爸媽媽都是觀察者，如果是`肚子餓事件`就交給媽媽餵奶，`換尿布事件`就交給爸爸換。

將這概念套回到RxSwift中，一個`被觀察者`可以被很多的`觀察者`訂閱，就像是爸爸媽媽關注自己的小孩一樣，而小孩的狀態會一直隨著時間而有不一樣的變化，所以我們可以產生下面這張圖，橫軸可以想像成時間，時間是由左往右移動，上面這些圓圈就是所謂的事件。

![](/Users/datou/Documents/Datou/onlyRxSwift/image/Screen Shot 2017-10-14 at 3.32.25 AM.png)

> Hint: 在RxSwift的世界中, Observable會產生所謂的事件, 當Observer訂閱之後, 就會針對收到的事件進行動作. 上圖中的箭號也俗稱為`Sequences`

**Observable**
顧名思義就是一個`可被觀察者`的, 

**Observer**

**Hot Signal vs Cold Signal：**
冷熱信號的概念源於C#的MVVM框架Reactive Extensions中的Hot Observables和Cold Observables: (這裡面的Observables可以理解為RACSignal。)

`Hot Observables`和`Cold Observables`的區別：
* `Hot Observables`是主動的，儘管你並沒有訂閱事件，但是它會時刻推送，就像鼠標移動；而`Cold Observables`是被動的，只有當你訂閱的時候，它才會發布消息。
* `Hot Observables`可以有多個訂閱者，是一對多，集合可以與訂閱者共享信息；而`Cold Observables`只能一對一，當有不同的訂閱者，消息是重新完整發送。
> Hint: 任何的信號轉換即是對原有的信號進行訂閱從而產生新的信號

**DisposeBag：**

### [RxSwift Community](https://github.com/RxSwiftCommunity)
[NSObject-Rx](https://github.com/RxSwiftCommunity/NSObject-Rx): 如果覺得一直宣告`disposeBag`很麻煩的話，可以考慮import這個.

### 巨人們 (我站在他們的肩膀看RxSwift):
* [ReactiveX/RxSwift.github](https://github.com/ReactiveX/RxSwift)
* [Thinking in RxSwift](http://adamborek.com/rxswift-materials-list/)
* [RxMarbles](http://rxmarbles.com/)
* https://academy.realm.io/posts/slug-max-alexander-mvvm-rxswift/?
* https://coderwall.com/p/vti_8w/rxswift-learning-resources
* https://www.teehanlax.com/blog/model-view-viewmodel-for-ios/