require 'chefspec'
require 'chefspec/berkshelf'

describe "gbg_familyfinder::default" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new() do |node|
      node.set['gbg_family_finder']['packages'] = %w(python unzip tar unixODBC admixture dbus blas-devel lapack-devel numpy scipy upstart vim freetds freetds-devel plinkbin git)
      node.set['gbg_family_finder']['upstart_config']  = %w(ff_activity.conf ff_bcp_activity.conf ffm_activity.conf ffm_async_workflow.conf ffm_misc_activity.conf ffm_workflow.conf ff_pf_activity.conf ff_pf_workflow.conf ff_sp_activity.conf ff_workflow.conf)
    end.converge(described_recipe)
  end

  %w[gbg_familyfinder::_base_packages gbg_familyfinder::_users].each do |inc_rec|
    it "includes #{inc_rec}" do
      expect(chef_run).to include_recipe(inc_rec)
    end
  end

#  %w[ff_activity.conf ff_bcp_activity.conf ffm_activity.conf ffm_async_workflow.conf ffm_misc_activity.conf ffm_workflow.conf ff_pf_activity.conf ff_pf_workflow.conf ff_pf_activity.conf ff_pf_workflow.conf ff_sp_activity.conf ff_workflow.conf].each do |file|
#    it 'configures upstart templates #{file}' do
#      expect(chef_run).to create_template(file).with(source: file, path: "/etc/init/#{file}", owner: "root", group: "root", mode: "0644")
#    end
#  end
end

