import { __ } from '~/locale';

export default (IssuableTokenKeys, disableTargetBranchFilter = false) => {
  const draftToken = {
    token: {
      formattedKey: __('Draft'),
      key: 'draft',
      type: 'string',
      param: '',
      symbol: '',
      icon: 'admin',
      tag: __('Yes or No'),
      lowercaseValueOnSubmit: true,
      capitalizeTokenValue: true,
    },
    conditions: [
      {
        url: 'wip=yes',
        // eslint-disable-next-line @gitlab/require-i18n-strings
        replacementUrl: 'draft=yes',
        tokenKey: 'draft',
        value: __('Yes'),
        operator: '=',
      },
      {
        url: 'wip=no',
        // eslint-disable-next-line @gitlab/require-i18n-strings
        replacementUrl: 'draft=no',
        tokenKey: 'draft',
        value: __('No'),
        operator: '=',
      },
      {
        url: 'not[wip]=yes',
        replacementUrl: 'not[draft]=yes',
        tokenKey: 'draft',
        value: __('Yes'),
        operator: '!=',
      },
      {
        url: 'not[wip]=no',
        replacementUrl: 'not[draft]=no',
        tokenKey: 'draft',
        value: __('No'),
        operator: '!=',
      },
    ],
  };

  IssuableTokenKeys.tokenKeys.push(draftToken.token);
  IssuableTokenKeys.tokenKeysWithAlternative.push(draftToken.token);
  IssuableTokenKeys.conditions.push(...draftToken.conditions);

  if (!disableTargetBranchFilter) {
    const targetBranchToken = {
      formattedKey: __('Target-Branch'),
      key: 'target-branch',
      type: 'string',
      param: '',
      symbol: '',
      icon: 'arrow-right',
      tag: 'branch',
    };

    IssuableTokenKeys.tokenKeys.push(targetBranchToken);
    IssuableTokenKeys.tokenKeysWithAlternative.push(targetBranchToken);
  }

  const approvedBy = {
    token: {
      formattedKey: __('Approved-By'),
      key: 'approved-by',
      type: 'array',
      param: 'usernames[]',
      symbol: '@',
      icon: 'approval',
      tag: '@approved-by',
    },
    condition: [
      {
        url: 'approved_by_usernames[]=None',
        tokenKey: 'approved-by',
        value: __('None'),
        operator: '=',
      },
      {
        url: 'not[approved_by_usernames][]=None',
        tokenKey: 'approved-by',
        value: __('None'),
        operator: '!=',
      },
      {
        url: 'approved_by_usernames[]=Any',
        tokenKey: 'approved-by',
        value: __('Any'),
        operator: '=',
      },
      {
        url: 'not[approved_by_usernames][]=Any',
        tokenKey: 'approved-by',
        value: __('Any'),
        operator: '!=',
      },
    ],
  };

  const tokenPosition = 2;
  IssuableTokenKeys.tokenKeys.splice(tokenPosition, 0, ...[approvedBy.token]);
  IssuableTokenKeys.tokenKeysWithAlternative.splice(tokenPosition, 0, ...[approvedBy.token]);
  IssuableTokenKeys.conditions.push(...approvedBy.condition);

  if (gon?.features?.deploymentFilters) {
    const environmentToken = {
      formattedKey: __('Environment'),
      key: 'environment',
      type: 'string',
      param: '',
      symbol: '',
      icon: 'cloud-gear',
      tag: 'environment',
    };

    const deployedBeforeToken = {
      formattedKey: __('Deployed-before'),
      key: 'deployed-before',
      type: 'string',
      param: '',
      symbol: '',
      icon: 'clock',
      tag: 'deployed_before',
    };

    const deployedAfterToken = {
      formattedKey: __('Deployed-after'),
      key: 'deployed-after',
      type: 'string',
      param: '',
      symbol: '',
      icon: 'clock',
      tag: 'deployed_after',
    };

    IssuableTokenKeys.tokenKeys.push(environmentToken, deployedBeforeToken, deployedAfterToken);

    IssuableTokenKeys.tokenKeysWithAlternative.push(
      environmentToken,
      deployedBeforeToken,
      deployedAfterToken,
    );
  }
};
