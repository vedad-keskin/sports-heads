package Box2D.Collision
{
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class Features
   {
      
      b2internal var _referenceEdge:int;
      
      b2internal var _incidentEdge:int;
      
      b2internal var _incidentVertex:int;
      
      b2internal var _flip:int;
      
      b2internal var _m_id:b2ContactID;
      
      public function Features()
      {
         super();
      }
      
      public function get referenceEdge() : int
      {
         return _referenceEdge;
      }
      
      public function set referenceEdge(param1:int) : void
      {
         _referenceEdge = param1;
         _m_id._key = _m_id._key & 0xFFFFFF00 | _referenceEdge & 0xFF;
      }
      
      public function get incidentEdge() : int
      {
         return _incidentEdge;
      }
      
      public function set incidentEdge(param1:int) : void
      {
         _incidentEdge = param1;
         _m_id._key = _m_id._key & 0xFFFF00FF | _incidentEdge << 8 & 0xFF00;
      }
      
      public function get incidentVertex() : int
      {
         return _incidentVertex;
      }
      
      public function set incidentVertex(param1:int) : void
      {
         _incidentVertex = param1;
         _m_id._key = _m_id._key & 0xFF00FFFF | _incidentVertex << 16 & 0xFF0000;
      }
      
      public function get flip() : int
      {
         return _flip;
      }
      
      public function set flip(param1:int) : void
      {
         _flip = param1;
         _m_id._key = _m_id._key & 0xFFFFFF | _flip << 24 & 0xFF000000;
      }
   }
}

