<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated>
      <q-toolbar>
        <q-btn
          flat
          dense
          round
          icon="menu"
          aria-label="Menu"
          @click="toggleLeftDrawer"
        />

        <q-toolbar-title> Portal </q-toolbar-title>

        <div>{{ $q.lang.nativeName }}</div>
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" show-if-above bordered>
      <q-list>
        <q-item-label header> BIKER SCUM PORTAL </q-item-label>

        <EssentialLink
          v-for="link in essentialLinks"
          :key="link.title"
          v-bind="link"
        />
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script lang="ts">
import { defineComponent, ref } from 'vue';
import EssentialLink from 'components/EssentialLink.vue';

const linksList = [
  {
    title: 'Scumbag',
    caption: 'Parts and recommendations for motorcycle mechanics.',
    icon: 'mic',
    link: 'https://www.bikerscum.ai/scumbag',
  },
  {
    title: 'Search',
    caption: 'Metasearch engine for tools and aftermarket Harley parts.',
    icon: 'saved_search',
    link: 'https://www.bikerscum.ai/search',
  },
  {
    title: 'Flywheels',
    caption: 'Truett & Osborn',
    icon: 'brightness_5',
    link: 'http://www.truettandosborn.com/Flywheels.htm',
  },
  {
    title: 'Engines',
    caption: 'S&S Cycle',
    icon: 'build',
    link: 'https://www.sscycle.com/search/?category=1|Engines',
  },
  {
    title: 'Discontinued Engines',
    caption: 'Semigalls',
    icon: 'build',
    link: 'https://semigalls.com/sscycle-sh103-engine-complete-assembled-alt-gen-engine-for-1970-99-custom-chassis',
  },
];

export default defineComponent({
  name: 'MainLayout',

  components: {
    EssentialLink,
  },

  setup() {
    const leftDrawerOpen = ref(false);

    return {
      essentialLinks: linksList,
      leftDrawerOpen,
      toggleLeftDrawer() {
        leftDrawerOpen.value = !leftDrawerOpen.value;
      },
    };
  },
});
</script>
