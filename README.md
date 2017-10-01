# RxSwift 學習心得 (持續更新中)

## MVVM
![](/Users/datou/Documents/Datou/onlyRxSwift/image/image1.png)
MVVM的大原則就是將原本在ViewController的View顯示邏輯，驗證邏輯，網絡請求等存放於ViewModel中, 盡量去避免所謂`Massive Controller`發生. 讓邏輯判斷等只有在ViewModel底下發生, 外界只需要領取結果即可.


## 進入RxSwift的世界
**Hot Signal vs Cold Signal:**
冷熱信號的概念源於C#的MVVM框架Reactive Extensions中的Hot Observables和Cold Observables: (這裡面的Observables可以理解為RACSignal。)

`Hot Observables`和`Cold Observables`的區別：
* `Hot Observables`是主動的，儘管你並沒有訂閱事件，但是它會時刻推送，就像鼠標移動；而`Cold Observables`是被動的，只有當你訂閱的時候，它才會發布消息。
* `Hot Observables`可以有多個訂閱者，是一對多，集合可以與訂閱者共享信息；而`Cold Observables`只能一對一，當有不同的訂閱者，消息是重新完整髮送。
> Hint: 任何的信號轉換即是對原有的信號進行訂閱從而產生新的信號




### 巨人們 (我站在他們的肩膀看RxSwift):
* [ReactiveX/RxSwift.github](https://github.com/ReactiveX/RxSwift)
* [Thinking in RxSwift](http://adamborek.com/rxswift-materials-list/)
* [RxMarbles](http://rxmarbles.com/)
* https://academy.realm.io/posts/slug-max-alexander-mvvm-rxswift/?
* https://coderwall.com/p/vti_8w/rxswift-learning-resources