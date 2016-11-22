class LFUCache {
protected:
    int cap=0;
    typedef pair<int, int> freq;
    typedef pair<int, int> cacheentry;
    vector<freq> freq_map;
    vector<cacheentry> cachemem;
    
public:
    LFUCache(int capacity) {
        cap=capacity;
    }
    
    int get(int key) {
        if(cap==0) return -1;
        for(int i=0; i<freq_map.size(); i++){
            if(freq_map[i].first==key) {
                freq_map[i].second++;
                freq f1=freq_map[i];
                freq_map.erase(freq_map.begin()+i);
                freq_map.push_back(f1);
                break;
            }
        }
        
        for(int i=0; i<cachemem.size(); i++){
            if(cachemem[i].first==key) {
                return cachemem[i].second;
            }
        }
        return -1;
    }
    
    void set(int key, int value) {
        //in the cache, hit
        int hit=0;
        for(int i=0; i<cachemem.size(); i++){
            if(cachemem[i].first==key){
                cachemem[i].second=value;
                hit=1;
                break;
            }
        }
        for(int i=0; i<freq_map.size(); i++){
            if(freq_map[i].first==key){
                freq_map[i].second++;
                freq ftmp=freq_map[i];
                freq_map.erase(freq_map.begin()+i);
                freq_map.push_back(ftmp);
                break;
            }
        }
        
        if(!hit && cap>0){
            if(cachemem.size()==cap){
                //evict
                int ev_key=freq_map[0].first;
                int min_freq=freq_map[0].second;
                
                for(int i=1; i<freq_map.size(); i++){
                    if(freq_map[i].second<min_freq){
                        ev_key=freq_map[i].first;
                        min_freq=freq_map[i].second;
                    }
                }
                
                for(int i=0; i<freq_map.size(); i++){
                    if(freq_map[i].first==ev_key){
                        freq_map.erase(freq_map.begin()+i);
                        break;
                    }
                }
                
                for(int i=0; i<cachemem.size(); i++){
                    if(cachemem[i].first==ev_key){
                        cachemem.erase(cachemem.begin()+i);
                        break;
                    }
                }
            }
            freq f1;
            f1.first=key;
            f1.second=1;
            cacheentry c1;
            c1.first=key;
            c1.second=value;
            cachemem.push_back(c1);
            freq_map.push_back(f1);
        }
    
        
    }
};

/**
 * The LFUCache object will be instantiated and called as such:
 * LFUCache obj = new LFUCache(capacity);
 * int param_1 = obj.get(key);
 * obj.set(key,value);
 */