<script>
import { mapActions } from 'vuex';

import { GlAlert, GlButton } from '@gitlab/ui';

import { CENTERED_LIMITED_CONTAINER_CLASSES } from '../constants';

export default {
  components: {
    GlAlert,
    GlButton,
  },
  props: {
    limited: {
      type: Boolean,
      required: false,
      default: false,
    },
    dismissed: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
  data() {
    return {
      isDismissed: this.dismissed,
    };
  },
  computed: {
    containerClasses() {
      return {
        [CENTERED_LIMITED_CONTAINER_CLASSES]: this.limited,
      };
    },
  },

  methods: {
    ...mapActions('diffs', ['expandAllFiles']),
    dismiss() {
      this.isDismissed = true;
      this.$emit('dismiss');
    },
    expand() {
      this.expandAllFiles();
      this.dismiss();
    },
  },
};
</script>

<template>
  <div v-if="!isDismissed" data-testid="root" :class="containerClasses" class="col-12">
    <gl-alert
      :dismissible="true"
      :title="__('Some changes are not shown')"
      variant="warning"
      class="gl-mb-5"
      @dismiss="dismiss"
    >
      <p class="gl-mb-0">
        {{ __('For a faster browsing experience, some files are collapsed by default.') }}
      </p>
      <template #actions>
        <gl-button category="secondary" variant="warning" class="gl-alert-action" @click="expand">
          {{ __('Expand all files') }}
        </gl-button>
      </template>
    </gl-alert>
  </div>
</template>
