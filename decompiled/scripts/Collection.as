package
{
   import flash.display.MovieClip;
   
   public class Collection
   {
      
      public var _collection:Array;
      
      public function Collection(... rest)
      {
         super();
         _collection = new Array();
         addItems(rest);
      }
      
      public function addItems(... rest) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         for each(_loc2_ in rest)
         {
            if(_loc2_ is Array)
            {
               for each(_loc3_ in _loc2_)
               {
                  addItems(_loc3_);
               }
            }
            else if(_loc2_ is Collection)
            {
               for each(_loc3_ in _loc2_.itemList)
               {
                  addItems(_loc3_);
               }
            }
            else if(!contains(_loc2_))
            {
               _collection.push(_loc2_);
            }
         }
      }
      
      public function removeItems(... rest) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         for each(_loc2_ in rest)
         {
            if(_loc2_ is Array)
            {
               for each(_loc3_ in _loc2_)
               {
                  removeItems(_loc3_);
               }
            }
            else if(_loc2_ is Collection)
            {
               for each(_loc3_ in _loc2_.itemList)
               {
                  removeItems(_loc3_);
               }
            }
            else if(contains(_loc2_))
            {
               _collection.splice(_collection.indexOf(_loc2_),1);
            }
         }
      }
      
      public function contains(param1:*) : Boolean
      {
         if(param1 is Array || param1 is Collection)
         {
            return containsAll(param1);
         }
         if(_collection.indexOf(param1) > -1 || this === param1)
         {
            return true;
         }
         return false;
      }
      
      public function containsAll(... rest) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Boolean = true;
         for each(_loc3_ in rest)
         {
            if(_loc3_ is Array)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(!_collection.containsAll(_loc4_))
                  {
                     _loc2_ = false;
                  }
               }
            }
            else if(_loc3_ is Collection)
            {
               for each(_loc4_ in _loc3_.itemList)
               {
                  if(!_collection.containsAll(_loc4_))
                  {
                     _loc2_ = false;
                  }
               }
            }
            else if(!_collection.contains(_loc3_))
            {
               _loc2_ = false;
            }
         }
         return _loc2_;
      }
      
      public function containsAny(... rest) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Boolean = false;
         for each(_loc3_ in rest)
         {
            if(_loc3_ is Array)
            {
               for each(_loc4_ in _loc3_)
               {
                  if(!_collection.containsAny(_loc4_))
                  {
                     _loc2_ = true;
                     break;
                  }
               }
            }
            else if(_loc3_ is Collection)
            {
               for each(_loc4_ in _loc3_.itemList)
               {
                  if(!_collection.containsAny(_loc4_))
                  {
                     _loc2_ = true;
                     break;
                  }
               }
            }
            else if(!_collection.contains(_loc3_))
            {
               _loc2_ = true;
               break;
            }
         }
         return _loc2_;
      }
      
      public function filter(param1:Function, param2:* = null) : Collection
      {
         var _loc3_:Collection = new Collection();
         _loc3_.addItems(_collection.filter(param1,param2));
         return _loc3_;
      }
      
      public function forEach(param1:Function, param2:* = null) : void
      {
         _collection.forEach(param1,param2);
      }
      
      public function join(param1:*) : String
      {
         return _collection.join(param1);
      }
      
      public function map(param1:Function, param2:* = null) : Collection
      {
         var _loc5_:* = undefined;
         var _loc3_:Array = _collection.map(param1,param2);
         var _loc4_:Collection = new Collection();
         for each(_loc5_ in _loc3_)
         {
            _loc4_.addItems(_loc5_);
         }
         return _loc4_;
      }
      
      public function some(param1:Function, param2:* = null) : Boolean
      {
         return _collection.some(param1,param2);
      }
      
      public function every(param1:Function, param2:* = null) : Boolean
      {
         return _collection.every(param1,param2);
      }
      
      public function subCollection(param1:String, param2:*) : Collection
      {
         var item:* = undefined;
         var property:String = param1;
         var value:* = param2;
         var subCollection:Collection = new Collection();
         for each(item in _collection)
         {
            try
            {
               if(item[property] == value)
               {
                  subCollection.addItems(item);
               }
            }
            catch(err:*)
            {
               break;
            }
         }
         return subCollection;
      }
      
      public function intersection(param1:Collection) : Collection
      {
         var _loc3_:* = undefined;
         var _loc2_:Collection = new Collection();
         for each(_loc3_ in param1.itemList)
         {
            if(this.contains(_loc3_))
            {
               _loc2_.addItems(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function intersectMany(... rest) : Collection
      {
         var _loc3_:* = undefined;
         var _loc2_:Collection = new Collection();
         _loc2_.addItems(_collection);
         for each(_loc3_ in rest)
         {
            if(_loc3_ is Collection)
            {
               _loc2_ = _loc2_.intersection(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function union(param1:Collection) : Collection
      {
         var _loc2_:Collection = new Collection();
         _loc2_.addItems(itemList,param1);
         return _loc2_;
      }
      
      public function unionMany(... rest) : Collection
      {
         var _loc3_:* = undefined;
         var _loc2_:Collection = new Collection();
         _loc2_.addItems(_collection);
         for each(_loc3_ in rest)
         {
            if(_loc3_ is Collection)
            {
               _loc2_ = _loc2_.union(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function relComp(param1:*) : Collection
      {
         var _loc2_:Collection = new Collection();
         _loc2_.addItems(_collection);
         _loc2_.removeItems(param1);
         return _loc2_;
      }
      
      public function relCompMany(... rest) : Collection
      {
         var _loc3_:* = undefined;
         var _loc2_:Collection = new Collection();
         _loc2_.addItems(_collection);
         for each(_loc3_ in rest)
         {
            if(_loc3_ is Collection)
            {
               _loc2_.removeItems(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function numItems() : uint
      {
         return _collection.length;
      }
      
      public function get itemList() : Array
      {
         return _collection;
      }
      
      public function removeAndDestroyContents(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         while(numItems() > 0)
         {
            for each(_loc2_ in itemList)
            {
               removeItems(_loc2_);
               param1.removeChild(_loc2_);
               _loc2_ = null;
            }
         }
      }
      
      public function removeAndDestroyDeleteMes(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:Collection = new Collection();
         for each(_loc3_ in itemList)
         {
            if(_loc3_.deleteme == true)
            {
               _loc2_.addItems(_loc3_);
            }
         }
         for each(_loc3_ in _loc2_.itemList)
         {
            removeItems(_loc3_);
            param1.removeChild(_loc3_);
            _loc3_ = null;
         }
      }
      
      public function runFunction(param1:String) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in itemList)
         {
            _loc2_[param1]();
         }
      }
      
      public function sendAllToTop() : void
      {
         var _loc1_:MovieClip = null;
         for each(_loc1_ in itemList)
         {
            if(MovieClip(_loc1_.parent) != null)
            {
               _loc1_.parent.setChildIndex(_loc1_,_loc1_.parent.numChildren - 1);
            }
         }
      }
      
      public function addItems2(... rest) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         for each(_loc2_ in rest)
         {
            if(_loc2_ is Array)
            {
               for each(_loc3_ in _loc2_)
               {
                  addItems(_loc3_);
               }
            }
            else if(_loc2_ is Collection)
            {
               for each(_loc3_ in _loc2_.itemList)
               {
                  addItems(_loc3_);
               }
            }
            else if(!contains(_loc2_))
            {
               _collection.push(_loc2_);
            }
         }
      }
   }
}

