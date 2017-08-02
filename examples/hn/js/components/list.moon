<template>
  <div class="container background">
    <div class="item" m-for="item,index in list">
      <p class="count light">{{(index + info.offset)}}</p>
      <div class="right-half">
        <p class="title" m-if="item.url === undefined"><router-link to="/item/{{item.id}}" class="no-decoration" rel="noopener">{{item.title}}</router-link></p>
        <p class="title" m-if="item.url !== undefined"><a href="{{item.url}}" class="no-decoration" rel="noopener">{{item.title}}</a> <span class="url light">({{base(item.url)}})</span></p>
        <p class="meta light">{{item.score}} points by <router-link to="/users/{{item.by}}" class="light">{{item.by}}</router-link> {{time(store, item.time)}}<span m-if="item.descendants !== undefined"> | <router-link to="/item/{{item.id}}" rel="noopener" class="light">{{item.descendants}} comments</router-link></span></p>
      </div>
    </div>
    <router-link to="/{{info.type}}/{{(info.page + 1)}}" class="next light" m-if="next === true">Next</router-link>
  </div>
</template>

<style scoped>
  .container.background {
    display: flex;
    flex-direction: column;
  }

  .item {
    display: flex;
  }

  .count {
    flex: 0 0 70px;
    margin-top: auto;
    margin-bottom: auto;
    font-weight: 100;
    font-size: 2.5rem;
    text-align: center;
  }

  .right-half {
    display: flex;
    flex-direction: column;
    justify-content: center;
    margin-top: 1rem;
    margin-bottom: 1rem;
  }

  .title a {
    font-size: 1.5rem;
  }

  .url {
    font-size: 1.2rem;
  }

  .meta {
    font-size: 1rem;
  }

  .next {
    align-self: center;
  }
</style>

<script>
  var store = require("../store/store.js").store;
  var base = require("../util/base.js");
  var time = require("../util/time.js");

  var info = {
    type: "",
    page: 0,
    offset: 0
  };

  exports = {
    props: ["route"],
    data: function() {
      return {
        list: [],
        info: info,
        next: false
      }
    },
    methods: {
      update: function() {
        var params = this.get("route").params;
        var type = params.type;
        var page = params.page;

        if(type === undefined) {
          type = "top";
        }

        if(page === undefined) {
          page = 1;
        } else {
          page = parseInt(page, 10);
        }

        if((type !== info.type) || (page !== info.page)) {
          var store = this.get("store");

          info.type = type;
          info.page = page;
          info.offset = (page * 30) - 29;
          store.dispatch("UPDATE_LISTS", info);
        }
      },
      base: base,
      time: time,
      scroll: function() {
        document.body.scrollTop = 0;
      }
    },
    hooks: {
      mounted: function() {
        info.instance = this;
        this.callMethod("update", []);
      },
      updated: function() {
        this.callMethod("update", []);
      },
      destroyed: function() {
        info.type = "";
        info.page = 0;
        info.offset = 0;
      }
    },
    store: store
  }
</script>
